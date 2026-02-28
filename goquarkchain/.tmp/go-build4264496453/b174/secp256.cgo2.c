
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


#line 1 "cgo-gcc-prolog"
/*
  If x and y are not equal, the type will be invalid
  (have a negative array count) and an inscrutable error will come
  out of the compiler and hopefully mention "name".
*/
#define __cgo_compile_assert_eq(x, y, name) typedef char name[(x-y)*(x-y)*-2UL+1UL];

/* Check at compile time that the sizes we use match our expectations. */
#define __cgo_size_assert(t, n) __cgo_compile_assert_eq(sizeof(t), (size_t)n, _cgo_sizeof_##t##_is_not_##n)

__cgo_size_assert(char, 1)
__cgo_size_assert(short, 2)
__cgo_size_assert(int, 4)
typedef long long __cgo_long_long;
__cgo_size_assert(__cgo_long_long, 8)
__cgo_size_assert(float, 4)
__cgo_size_assert(double, 8)

extern char* _cgo_topofstack(void);

/*
  We use packed structs, but they are always aligned.
  The pragmas and address-of-packed-member are only recognized as warning
  groups in clang 4.0+, so ignore unknown pragmas first.
*/
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma GCC diagnostic ignored "-Wpragmas"
#pragma GCC diagnostic ignored "-Waddress-of-packed-member"
#pragma GCC diagnostic ignored "-Wunknown-warning-option"
#pragma GCC diagnostic ignored "-Wunaligned-access"

#include <errno.h>
#include <string.h>


#define CGO_NO_SANITIZE_THREAD
#define _cgo_tsan_acquire()
#define _cgo_tsan_release()


#define _cgo_msan_write(addr, sz)

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_context_create_sign_verify(void *v)
{
	struct {
		secp256k1_context* r;
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = (__typeof__(_cgo_a->r)) secp256k1_context_create_sign_verify();
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_context_set_error_callback(void *v)
{
	struct {
		secp256k1_context* p0;
		void* p1;
		const void* p2;
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	_cgo_tsan_acquire();
	secp256k1_context_set_error_callback(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2);
	_cgo_tsan_release();
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_context_set_illegal_callback(void *v)
{
	struct {
		secp256k1_context* p0;
		void* p1;
		const void* p2;
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	_cgo_tsan_acquire();
	secp256k1_context_set_illegal_callback(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2);
	_cgo_tsan_release();
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ec_seckey_verify(void *v)
{
	struct {
		secp256k1_context const* p0;
		unsigned char const* p1;
		int r;
		char __pad20[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ec_seckey_verify(_cgo_a->p0, _cgo_a->p1);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ecdsa_recoverable_signature_serialize_compact(void *v)
{
	struct {
		secp256k1_context const* p0;
		unsigned char* p1;
		int* p2;
		secp256k1_ecdsa_recoverable_signature const* p3;
		int r;
		char __pad36[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ecdsa_recoverable_signature_serialize_compact(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2, _cgo_a->p3);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ecdsa_sign_recoverable(void *v)
{
	struct {
		secp256k1_context const* p0;
		secp256k1_ecdsa_recoverable_signature* p1;
		unsigned char const* p2;
		unsigned char const* p3;
		void* p4;
		const void* p5;
		int r;
		char __pad52[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ecdsa_sign_recoverable(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2, _cgo_a->p3, _cgo_a->p4, _cgo_a->p5);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ext_ecdsa_recover(void *v)
{
	struct {
		secp256k1_context const* p0;
		unsigned char* p1;
		unsigned char const* p2;
		unsigned char const* p3;
		int r;
		char __pad36[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ext_ecdsa_recover(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2, _cgo_a->p3);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ext_ecdsa_verify(void *v)
{
	struct {
		secp256k1_context const* p0;
		unsigned char const* p1;
		unsigned char const* p2;
		unsigned char const* p3;
		size_t p4;
		int r;
		char __pad44[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ext_ecdsa_verify(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2, _cgo_a->p3, _cgo_a->p4);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

CGO_NO_SANITIZE_THREAD
void
_cgo_1fc93ead4968_Cfunc_secp256k1_ext_reencode_pubkey(void *v)
{
	struct {
		secp256k1_context const* p0;
		unsigned char* p1;
		size_t p2;
		unsigned char const* p3;
		size_t p4;
		int r;
		char __pad44[4];
	} __attribute__((__packed__, __gcc_struct__)) *_cgo_a = v;
	char *_cgo_stktop = _cgo_topofstack();
	__typeof__(_cgo_a->r) _cgo_r;
	_cgo_tsan_acquire();
	_cgo_r = secp256k1_ext_reencode_pubkey(_cgo_a->p0, _cgo_a->p1, _cgo_a->p2, _cgo_a->p3, _cgo_a->p4);
	_cgo_tsan_release();
	_cgo_a = (void*)((char*)_cgo_a + (_cgo_topofstack() - _cgo_stktop));
	_cgo_a->r = _cgo_r;
	_cgo_msan_write(&_cgo_a->r, sizeof(_cgo_a->r));
}

