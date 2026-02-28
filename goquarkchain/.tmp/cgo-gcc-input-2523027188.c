
#line 1 "cgo-builtin-prolog"
#include <stddef.h>

/* Define intgo when compiling with GCC.  */
typedef ptrdiff_t intgo;

#define GO_CGO_GOSTRING_TYPEDEF
typedef struct { const char *p; intgo n; } _GoString_;
typedef struct { char *p; intgo n; intgo c; } _GoBytes_;
_GoString_ GoString(char *p);
_GoString_ GoStringN(char *p, int l);
_GoBytes_ GoBytes(void *p, int n);
char *CString(_GoString_);
void *CBytes(_GoBytes_);
void *_CMalloc(size_t);

__attribute__ ((unused))
static size_t _GoStringLen(_GoString_ s) { return (size_t)s.n; }

__attribute__ ((unused))
static const char *_GoStringPtr(_GoString_ s) { return s.p; }
#line 1 "not-declared"
void __cgo_f_1_1(void) { __typeof__(GoString) *__cgo_undefined__1; }
#line 1 "not-type"
void __cgo_f_1_2(void) { GoString *__cgo_undefined__2; }
#line 1 "not-int-const"
void __cgo_f_1_3(void) { enum { __cgo_undefined__3 = (GoString)*1 }; }
#line 1 "not-num-const"
void __cgo_f_1_4(void) { static const double __cgo_undefined__4 = (GoString); }
#line 1 "not-str-lit"
void __cgo_f_1_5(void) { static const char __cgo_undefined__5[] = (GoString); }
#line 2 "not-declared"
void __cgo_f_2_1(void) { __typeof__(_GoString_) *__cgo_undefined__1; }
#line 2 "not-type"
void __cgo_f_2_2(void) { _GoString_ *__cgo_undefined__2; }
#line 2 "not-int-const"
void __cgo_f_2_3(void) { enum { __cgo_undefined__3 = (_GoString_)*1 }; }
#line 2 "not-num-const"
void __cgo_f_2_4(void) { static const double __cgo_undefined__4 = (_GoString_); }
#line 2 "not-str-lit"
void __cgo_f_2_5(void) { static const char __cgo_undefined__5[] = (_GoString_); }
#line 3 "not-declared"
void __cgo_f_3_1(void) { __typeof__(char) *__cgo_undefined__1; }
#line 3 "not-type"
void __cgo_f_3_2(void) { char *__cgo_undefined__2; }
#line 3 "not-int-const"
void __cgo_f_3_3(void) { enum { __cgo_undefined__3 = (char)*1 }; }
#line 3 "not-num-const"
void __cgo_f_3_4(void) { static const double __cgo_undefined__4 = (char); }
#line 3 "not-str-lit"
void __cgo_f_3_5(void) { static const char __cgo_undefined__5[] = (char); }
#line 4 "not-declared"
void __cgo_f_4_1(void) { __typeof__(intgo) *__cgo_undefined__1; }
#line 4 "not-type"
void __cgo_f_4_2(void) { intgo *__cgo_undefined__2; }
#line 4 "not-int-const"
void __cgo_f_4_3(void) { enum { __cgo_undefined__3 = (intgo)*1 }; }
#line 4 "not-num-const"
void __cgo_f_4_4(void) { static const double __cgo_undefined__4 = (intgo); }
#line 4 "not-str-lit"
void __cgo_f_4_5(void) { static const char __cgo_undefined__5[] = (intgo); }
#line 5 "not-declared"
void __cgo_f_5_1(void) { __typeof__(ptrdiff_t) *__cgo_undefined__1; }
#line 5 "not-type"
void __cgo_f_5_2(void) { ptrdiff_t *__cgo_undefined__2; }
#line 5 "not-int-const"
void __cgo_f_5_3(void) { enum { __cgo_undefined__3 = (ptrdiff_t)*1 }; }
#line 5 "not-num-const"
void __cgo_f_5_4(void) { static const double __cgo_undefined__4 = (ptrdiff_t); }
#line 5 "not-str-lit"
void __cgo_f_5_5(void) { static const char __cgo_undefined__5[] = (ptrdiff_t); }
#line 1 "completed"
int __cgo__1 = __cgo__2;
