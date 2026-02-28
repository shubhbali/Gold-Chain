
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
#line 1 "cgo-dwarf-inference"
__typeof__(secp256k1_context) *__cgo__0;
__typeof__(secp256k1_ext_scalar_mul) *__cgo__1;
__typeof__(unsigned char) *__cgo__2;
long long __cgodebug_ints[] = {
	0,
	0,
	0,
	1
};
double __cgodebug_floats[] = {
	0,
	0,
	0,
	1
};
