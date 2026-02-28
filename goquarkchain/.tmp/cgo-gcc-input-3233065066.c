
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
#line 8 "C:\\gold\\.gomodcache\\github.com\\ethereum\\go-ethereum@v1.8.20\\crypto\\secp256k1\\secp256.go"



#define USE_NUM_NONE
#define USE_FIELD_10X26
#define USE_FIELD_INV_BUILTIN
#define USE_SCALAR_8X32
#define USE_SCALAR_INV_BUILTIN
#define NDEBUG
#include "./libsecp256k1/src/secp256k1.c"
#include "./libsecp256k1/src/modules/recovery/main_impl.h"
#include "ext.h"

typedef void (*callbackFunc) (const char* msg, void* data);
extern void secp256k1GoPanicIllegal(const char* msg, void* data);
extern void secp256k1GoPanicError(const char* msg, void* data);

#line 1 "cgo-generated-wrapper"
#line 1 "cgo-dwarf-inference"
__typeof__(callbackFunc) *__cgo__0;
__typeof__(int) *__cgo__1;
__typeof__(secp256k1GoPanicError) *__cgo__2;
__typeof__(secp256k1GoPanicIllegal) *__cgo__3;
__typeof__(secp256k1_context) *__cgo__4;
__typeof__(secp256k1_context_create_sign_verify) *__cgo__5;
__typeof__(secp256k1_context_set_error_callback) *__cgo__6;
__typeof__(secp256k1_context_set_illegal_callback) *__cgo__7;
__typeof__(secp256k1_ec_seckey_verify) *__cgo__8;
__typeof__(secp256k1_ecdsa_recoverable_signature) *__cgo__9;
__typeof__(secp256k1_ecdsa_recoverable_signature_serialize_compact) *__cgo__10;
__typeof__(secp256k1_ecdsa_sign_recoverable) *__cgo__11;
__typeof__(secp256k1_ext_ecdsa_recover) *__cgo__12;
__typeof__(secp256k1_ext_ecdsa_verify) *__cgo__13;
__typeof__(secp256k1_ext_reencode_pubkey) *__cgo__14;
__typeof__(secp256k1_nonce_function_rfc6979) *__cgo__15;
__typeof__(size_t) *__cgo__16;
__typeof__(unsigned char) *__cgo__17;
long long __cgodebug_ints[] = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	1
};
double __cgodebug_floats[] = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	1
};
