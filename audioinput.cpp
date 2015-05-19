
#include <stdlib.h>
#include <math.h>

#include <QDateTime>
#include <QDebug>
#include <QAudioDeviceInfo>
#include <QAudioInput>
#include <qendian.h>

#include "audioinput.h"

#define PUSH_MODE_LABEL "Enable push mode"
#define PULL_MODE_LABEL "Enable pull mode"
#define SUSPEND_LABEL   "Suspend recording"
#define RESUME_LABEL    "Resume recording"

const int BufferSize = 4096;

AudioInfo::AudioInfo(const QAudioFormat &format, QObject *parent)
    :   QIODevice(parent)
    ,   m_format(format)
    ,   m_maxAmplitude(0)
    ,   m_level(0.0)

{
    switch (m_format.sampleSize()) {
    case 8:
        switch (m_format.sampleType()) {
        case QAudioFormat::UnSignedInt:
            m_maxAmplitude = 255;
            break;
        case QAudioFormat::SignedInt:
            m_maxAmplitude = 127;
            break;
        default:
            break;
        }
        break;
    case 16:
        switch (m_format.sampleType()) {
        case QAudioFormat::UnSignedInt:
            m_maxAmplitude = 65535;
            break;
        case QAudioFormat::SignedInt:
            m_maxAmplitude = 32767;
            break;
        default:
            break;
        }
        break;

    case 32:
        switch (m_format.sampleType()) {
        case QAudioFormat::UnSignedInt:
            m_maxAmplitude = 0xffffffff;
            break;
        case QAudioFormat::SignedInt:
            m_maxAmplitude = 0x7fffffff;
            break;
        case QAudioFormat::Float:
            m_maxAmplitude = 0x7fffffff; // Kind of
        default:
            break;
        }
        break;

    default:
        break;
    }
}

AudioInfo::~AudioInfo()
{
}

void AudioInfo::start()
{
    open(QIODevice::WriteOnly);
}

void AudioInfo::stop()
{
    close();
}

qint64 AudioInfo::readData(char *data, qint64 maxlen)
{
    Q_UNUSED(data)
    Q_UNUSED(maxlen)

    return 0;
}

qint64 AudioInfo::writeData(const char *data, qint64 len)
{
    //qDebug<<"Wrtedata";
    if (m_maxAmplitude) {
        Q_ASSERT(m_format.sampleSize() % 8 == 0);
        const int channelBytes = m_format.sampleSize() / 8;
        const int sampleBytes = m_format.channelCount() * channelBytes;
        Q_ASSERT(len % sampleBytes == 0);
        const int numSamples = len / sampleBytes;

        quint32 maxValue = 0;
        const unsigned char *ptr = reinterpret_cast<const unsigned char *>(data);

        for (int i = 0; i < numSamples; ++i) {
            for (int j = 0; j < m_format.channelCount(); ++j) {
                quint32 value = 0;

                if (m_format.sampleSize() == 8 && m_format.sampleType() == QAudioFormat::UnSignedInt) {
                    value = *reinterpret_cast<const quint8*>(ptr);
                } else if (m_format.sampleSize() == 8 && m_format.sampleType() == QAudioFormat::SignedInt) {
                    value = qAbs(*reinterpret_cast<const qint8*>(ptr));
                } else if (m_format.sampleSize() == 16 && m_format.sampleType() == QAudioFormat::UnSignedInt) {
                    if (m_format.byteOrder() == QAudioFormat::LittleEndian)
                        value = qFromLittleEndian<quint16>(ptr);
                    else
                        value = qFromBigEndian<quint16>(ptr);
                } else if (m_format.sampleSize() == 16 && m_format.sampleType() == QAudioFormat::SignedInt) {
                    if (m_format.byteOrder() == QAudioFormat::LittleEndian)
                        value = qAbs(qFromLittleEndian<qint16>(ptr));
                    else
                        value = qAbs(qFromBigEndian<qint16>(ptr));
                } else if (m_format.sampleSize() == 32 && m_format.sampleType() == QAudioFormat::UnSignedInt) {
                    if (m_format.byteOrder() == QAudioFormat::LittleEndian)
                        value = qFromLittleEndian<quint32>(ptr);
                    else
                        value = qFromBigEndian<quint32>(ptr);
                } else if (m_format.sampleSize() == 32 && m_format.sampleType() == QAudioFormat::SignedInt) {
                    if (m_format.byteOrder() == QAudioFormat::LittleEndian)
                        value = qAbs(qFromLittleEndian<qint32>(ptr));
                    else
                        value = qAbs(qFromBigEndian<qint32>(ptr));
                } else if (m_format.sampleSize() == 32 && m_format.sampleType() == QAudioFormat::Float) {
                    value = qAbs(*reinterpret_cast<const float*>(ptr) * 0x7fffffff); // assumes 0-1.0
                }

                maxValue = qMax(value, maxValue);
                ptr += channelBytes;
            }
        }

        maxValue = qMin(maxValue, m_maxAmplitude);
        m_level = qreal(maxValue) / m_maxAmplitude;
    }

    emit update();
    return len;
}




InputTest::InputTest()
    :   m_device(QAudioDeviceInfo::defaultInputDevice())
    ,   m_audioInfo(0)
    ,   m_audioInput(0)
    ,   m_input(0)
    ,   m_pullMode(true)
    ,   m_buffer(BufferSize, 0)
{
    initializeAudio();
     qDebug() << "initaudio";
}

InputTest::~InputTest() {}

void InputTest::initializeAudio()
{
    m_pullMode = true;
    m_format.setSampleRate(8000);
    m_format.setChannelCount(1);
    m_format.setSampleSize(16);
    m_format.setSampleType(QAudioFormat::SignedInt);
    m_format.setByteOrder(QAudioFormat::LittleEndian);
    m_format.setCodec("audio/pcm");
    qDebug() << "m_format";

    QAudioDeviceInfo info(QAudioDeviceInfo::defaultInputDevice());
    if (!info.isFormatSupported(m_format)) {
        qWarning() << "Default format not supported - trying to use nearest";
        m_format = info.nearestFormat(m_format);
        qDebug() << m_format;
    }

    m_audioInfo  = new AudioInfo(m_format, this);
    connect(m_audioInfo, SIGNAL(update()), SLOT(refreshDisplay()));

    createAudioInput();
}

void InputTest::createAudioInput()
{
    m_audioInput = new QAudioInput(m_device, m_format, this);
    //m_volumeSlider->setValue(m_audioInput->volume() * 100);
    m_audioInfo->start();
    m_audioInput->start(m_audioInfo);
    qDebug() << "createAudioInput";
}

void InputTest::readMore()
{
    qDebug() << "readmore";
    if (!m_audioInput)
        return;
    qint64 len = m_audioInput->bytesReady();
    if (len > BufferSize)
        len = BufferSize;
    qint64 l = m_input->read(m_buffer.data(), len);
    if (l > 0)
        m_audioInfo->write(m_buffer.constData(), l);
}

void InputTest::toggleMode()
{
    // Change bewteen pull and push modes
    m_audioInput->stop();

    if (m_pullMode) {
        m_input = m_audioInput->start();
        connect(m_input, SIGNAL(readyRead()), SLOT(readMore()));
        m_pullMode = false;
    } else {
        m_pullMode = true;
        m_audioInput->start(m_audioInfo);
    }

    //m_suspendResumeButton->setText(tr(SUSPEND_LABEL));
}

void InputTest::toggleSuspend()
{
    // toggle suspend/resume
    if (m_audioInput->state() == QAudio::SuspendedState) {
        m_audioInput->resume();
    } else if (m_audioInput->state() == QAudio::ActiveState) {
        m_audioInput->suspend();
    } else if (m_audioInput->state() == QAudio::StoppedState) {
    } else if (m_audioInput->state() == QAudio::IdleState) {
        // no-op
    }
}

void InputTest::refreshDisplay()
{
   // m_canvas->setLevel(m_audioInfo->level());
}
qreal InputTest::getvollevel()
{
    return m_audioInfo->level();
}

void InputTest::deviceChanged(int index)
{
    m_audioInfo->stop();
    m_audioInput->stop();
    m_audioInput->disconnect(this);
    delete m_audioInput;

    //m_device = m_deviceBox->itemData(index).value<QAudioDeviceInfo>();
    createAudioInput();
}

void InputTest::sliderChanged(int value)
{
    if (m_audioInput)
        m_audioInput->setVolume(qreal(value) / 100);
}
