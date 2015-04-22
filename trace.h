#ifndef TRACE_H
#define TRACE_H

#include <QDebug>

#define ENABLE_TRACE
//#define VERBOSE_TRACE

namespace Trace {

class NullDebug
{
public:
    template <typename T>
    NullDebug &operator<<(const T &) { return *this; }
};

inline NullDebug nullDebug() { return NullDebug(); }

template <typename T>
struct PtrWrapper
{
    PtrWrapper(const T *ptr) : m_ptr(ptr) { }
    const T *const m_ptr;
};

} // namespace Trace

template <typename T>
inline QDebug &operator<<(QDebug &debug, const Trace::PtrWrapper<T> &wrapper)
{
    debug.nospace() << "[" << (void*)wrapper.m_ptr << "]";
    return debug.space();
}

#ifdef ENABLE_TRACE
        inline QDebug qtTrace() { return qDebug() << "[qmlvideofx]"; }
#    ifdef VERBOSE_TRACE
        inline QDebug qtVerboseTrace() { return qtTrace(); }
#    else
        inline Trace::NullDebug qtVerboseTrace() { return Trace::nullDebug(); }
#    endif
#else
    inline Trace::NullDebug qtTrace() { return Trace::nullDebug(); }
    inline Trace::NullDebug qtVerboseTrace() { return Trace::nullDebug(); }
#endif

#endif // TRACE_H
