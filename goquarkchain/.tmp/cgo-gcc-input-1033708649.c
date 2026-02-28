
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
#line 41 "C:\\gold\\.gomodcache\\github.com\\ethereum\\go-ethereum@v1.8.20\\crypto\\secp256k1\\curve.go"

#include "libsecp256k1/include/secp256k1.h"
extern int secp256k1_ext_scalar_mul(const secp256k1_context* ctx, const unsigned char *point, const unsigned char *scalar);

#line 1 "cgo-generated-wrapper"
#line 1 "not-declared"
void __cgo_f_1_1(void) { __typeof__(secp256k1_ext_scalar_mul) *__cgo_undefined__1; }
#line 1 "not-type"
void __cgo_f_1_2(void) { secp256k1_ext_scalar_mul *__cgo_undefined__2; }
#line 1 "not-int-const"
void __cgo_f_1_3(void) { enum { __cgo_undefined__3 = (secp256k1_ext_scalar_mul)*1 }; }
#line 1 "not-num-const"
void __cgo_f_1_4(void) { static const double __cgo_undefined__4 = (secp256k1_ext_scalar_mul); }
#line 1 "not-str-lit"
void __cgo_f_1_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ext_scalar_mul); }
#line 2 "not-declared"
void __cgo_f_2_1(void) { __typeof__(unsigned char) *__cgo_undefined__1; }
#line 2 "not-type"
void __cgo_f_2_2(void) { unsigned char *__cgo_undefined__2; }
#line 2 "not-int-const"
void __cgo_f_2_3(void) { enum { __cgo_undefined__3 = (unsigned char)*1 }; }
#line 2 "not-num-const"
void __cgo_f_2_4(void) { static const double __cgo_undefined__4 = (unsigned char); }
#line 2 "not-str-lit"
void __cgo_f_2_5(void) { static const char __cgo_undefined__5[] = (unsigned char); }
#line 1 "completed"
int __cgo__1 = __cgo__2;
