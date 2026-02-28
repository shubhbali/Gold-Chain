
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
#line 1 "not-declared"
void __cgo_f_1_1(void) { __typeof__(callbackFunc) *__cgo_undefined__1; }
#line 1 "not-type"
void __cgo_f_1_2(void) { callbackFunc *__cgo_undefined__2; }
#line 1 "not-int-const"
void __cgo_f_1_3(void) { enum { __cgo_undefined__3 = (callbackFunc)*1 }; }
#line 1 "not-num-const"
void __cgo_f_1_4(void) { static const double __cgo_undefined__4 = (callbackFunc); }
#line 1 "not-str-lit"
void __cgo_f_1_5(void) { static const char __cgo_undefined__5[] = (callbackFunc); }
#line 2 "not-declared"
void __cgo_f_2_1(void) { __typeof__(int) *__cgo_undefined__1; }
#line 2 "not-type"
void __cgo_f_2_2(void) { int *__cgo_undefined__2; }
#line 2 "not-int-const"
void __cgo_f_2_3(void) { enum { __cgo_undefined__3 = (int)*1 }; }
#line 2 "not-num-const"
void __cgo_f_2_4(void) { static const double __cgo_undefined__4 = (int); }
#line 2 "not-str-lit"
void __cgo_f_2_5(void) { static const char __cgo_undefined__5[] = (int); }
#line 3 "not-declared"
void __cgo_f_3_1(void) { __typeof__(secp256k1GoPanicError) *__cgo_undefined__1; }
#line 3 "not-type"
void __cgo_f_3_2(void) { secp256k1GoPanicError *__cgo_undefined__2; }
#line 3 "not-int-const"
void __cgo_f_3_3(void) { enum { __cgo_undefined__3 = (secp256k1GoPanicError)*1 }; }
#line 3 "not-num-const"
void __cgo_f_3_4(void) { static const double __cgo_undefined__4 = (secp256k1GoPanicError); }
#line 3 "not-str-lit"
void __cgo_f_3_5(void) { static const char __cgo_undefined__5[] = (secp256k1GoPanicError); }
#line 4 "not-declared"
void __cgo_f_4_1(void) { __typeof__(secp256k1GoPanicIllegal) *__cgo_undefined__1; }
#line 4 "not-type"
void __cgo_f_4_2(void) { secp256k1GoPanicIllegal *__cgo_undefined__2; }
#line 4 "not-int-const"
void __cgo_f_4_3(void) { enum { __cgo_undefined__3 = (secp256k1GoPanicIllegal)*1 }; }
#line 4 "not-num-const"
void __cgo_f_4_4(void) { static const double __cgo_undefined__4 = (secp256k1GoPanicIllegal); }
#line 4 "not-str-lit"
void __cgo_f_4_5(void) { static const char __cgo_undefined__5[] = (secp256k1GoPanicIllegal); }
#line 5 "not-declared"
void __cgo_f_5_1(void) { __typeof__(secp256k1_context) *__cgo_undefined__1; }
#line 5 "not-type"
void __cgo_f_5_2(void) { secp256k1_context *__cgo_undefined__2; }
#line 5 "not-int-const"
void __cgo_f_5_3(void) { enum { __cgo_undefined__3 = (secp256k1_context)*1 }; }
#line 5 "not-num-const"
void __cgo_f_5_4(void) { static const double __cgo_undefined__4 = (secp256k1_context); }
#line 5 "not-str-lit"
void __cgo_f_5_5(void) { static const char __cgo_undefined__5[] = (secp256k1_context); }
#line 6 "not-declared"
void __cgo_f_6_1(void) { __typeof__(secp256k1_context_create_sign_verify) *__cgo_undefined__1; }
#line 6 "not-type"
void __cgo_f_6_2(void) { secp256k1_context_create_sign_verify *__cgo_undefined__2; }
#line 6 "not-int-const"
void __cgo_f_6_3(void) { enum { __cgo_undefined__3 = (secp256k1_context_create_sign_verify)*1 }; }
#line 6 "not-num-const"
void __cgo_f_6_4(void) { static const double __cgo_undefined__4 = (secp256k1_context_create_sign_verify); }
#line 6 "not-str-lit"
void __cgo_f_6_5(void) { static const char __cgo_undefined__5[] = (secp256k1_context_create_sign_verify); }
#line 7 "not-declared"
void __cgo_f_7_1(void) { __typeof__(secp256k1_context_set_error_callback) *__cgo_undefined__1; }
#line 7 "not-type"
void __cgo_f_7_2(void) { secp256k1_context_set_error_callback *__cgo_undefined__2; }
#line 7 "not-int-const"
void __cgo_f_7_3(void) { enum { __cgo_undefined__3 = (secp256k1_context_set_error_callback)*1 }; }
#line 7 "not-num-const"
void __cgo_f_7_4(void) { static const double __cgo_undefined__4 = (secp256k1_context_set_error_callback); }
#line 7 "not-str-lit"
void __cgo_f_7_5(void) { static const char __cgo_undefined__5[] = (secp256k1_context_set_error_callback); }
#line 8 "not-declared"
void __cgo_f_8_1(void) { __typeof__(secp256k1_context_set_illegal_callback) *__cgo_undefined__1; }
#line 8 "not-type"
void __cgo_f_8_2(void) { secp256k1_context_set_illegal_callback *__cgo_undefined__2; }
#line 8 "not-int-const"
void __cgo_f_8_3(void) { enum { __cgo_undefined__3 = (secp256k1_context_set_illegal_callback)*1 }; }
#line 8 "not-num-const"
void __cgo_f_8_4(void) { static const double __cgo_undefined__4 = (secp256k1_context_set_illegal_callback); }
#line 8 "not-str-lit"
void __cgo_f_8_5(void) { static const char __cgo_undefined__5[] = (secp256k1_context_set_illegal_callback); }
#line 9 "not-declared"
void __cgo_f_9_1(void) { __typeof__(secp256k1_ec_seckey_verify) *__cgo_undefined__1; }
#line 9 "not-type"
void __cgo_f_9_2(void) { secp256k1_ec_seckey_verify *__cgo_undefined__2; }
#line 9 "not-int-const"
void __cgo_f_9_3(void) { enum { __cgo_undefined__3 = (secp256k1_ec_seckey_verify)*1 }; }
#line 9 "not-num-const"
void __cgo_f_9_4(void) { static const double __cgo_undefined__4 = (secp256k1_ec_seckey_verify); }
#line 9 "not-str-lit"
void __cgo_f_9_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ec_seckey_verify); }
#line 10 "not-declared"
void __cgo_f_10_1(void) { __typeof__(secp256k1_ecdsa_recoverable_signature) *__cgo_undefined__1; }
#line 10 "not-type"
void __cgo_f_10_2(void) { secp256k1_ecdsa_recoverable_signature *__cgo_undefined__2; }
#line 10 "not-int-const"
void __cgo_f_10_3(void) { enum { __cgo_undefined__3 = (secp256k1_ecdsa_recoverable_signature)*1 }; }
#line 10 "not-num-const"
void __cgo_f_10_4(void) { static const double __cgo_undefined__4 = (secp256k1_ecdsa_recoverable_signature); }
#line 10 "not-str-lit"
void __cgo_f_10_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ecdsa_recoverable_signature); }
#line 11 "not-declared"
void __cgo_f_11_1(void) { __typeof__(secp256k1_ecdsa_recoverable_signature_serialize_compact) *__cgo_undefined__1; }
#line 11 "not-type"
void __cgo_f_11_2(void) { secp256k1_ecdsa_recoverable_signature_serialize_compact *__cgo_undefined__2; }
#line 11 "not-int-const"
void __cgo_f_11_3(void) { enum { __cgo_undefined__3 = (secp256k1_ecdsa_recoverable_signature_serialize_compact)*1 }; }
#line 11 "not-num-const"
void __cgo_f_11_4(void) { static const double __cgo_undefined__4 = (secp256k1_ecdsa_recoverable_signature_serialize_compact); }
#line 11 "not-str-lit"
void __cgo_f_11_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ecdsa_recoverable_signature_serialize_compact); }
#line 12 "not-declared"
void __cgo_f_12_1(void) { __typeof__(secp256k1_ecdsa_sign_recoverable) *__cgo_undefined__1; }
#line 12 "not-type"
void __cgo_f_12_2(void) { secp256k1_ecdsa_sign_recoverable *__cgo_undefined__2; }
#line 12 "not-int-const"
void __cgo_f_12_3(void) { enum { __cgo_undefined__3 = (secp256k1_ecdsa_sign_recoverable)*1 }; }
#line 12 "not-num-const"
void __cgo_f_12_4(void) { static const double __cgo_undefined__4 = (secp256k1_ecdsa_sign_recoverable); }
#line 12 "not-str-lit"
void __cgo_f_12_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ecdsa_sign_recoverable); }
#line 13 "not-declared"
void __cgo_f_13_1(void) { __typeof__(secp256k1_ext_ecdsa_recover) *__cgo_undefined__1; }
#line 13 "not-type"
void __cgo_f_13_2(void) { secp256k1_ext_ecdsa_recover *__cgo_undefined__2; }
#line 13 "not-int-const"
void __cgo_f_13_3(void) { enum { __cgo_undefined__3 = (secp256k1_ext_ecdsa_recover)*1 }; }
#line 13 "not-num-const"
void __cgo_f_13_4(void) { static const double __cgo_undefined__4 = (secp256k1_ext_ecdsa_recover); }
#line 13 "not-str-lit"
void __cgo_f_13_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ext_ecdsa_recover); }
#line 14 "not-declared"
void __cgo_f_14_1(void) { __typeof__(secp256k1_ext_ecdsa_verify) *__cgo_undefined__1; }
#line 14 "not-type"
void __cgo_f_14_2(void) { secp256k1_ext_ecdsa_verify *__cgo_undefined__2; }
#line 14 "not-int-const"
void __cgo_f_14_3(void) { enum { __cgo_undefined__3 = (secp256k1_ext_ecdsa_verify)*1 }; }
#line 14 "not-num-const"
void __cgo_f_14_4(void) { static const double __cgo_undefined__4 = (secp256k1_ext_ecdsa_verify); }
#line 14 "not-str-lit"
void __cgo_f_14_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ext_ecdsa_verify); }
#line 15 "not-declared"
void __cgo_f_15_1(void) { __typeof__(secp256k1_ext_reencode_pubkey) *__cgo_undefined__1; }
#line 15 "not-type"
void __cgo_f_15_2(void) { secp256k1_ext_reencode_pubkey *__cgo_undefined__2; }
#line 15 "not-int-const"
void __cgo_f_15_3(void) { enum { __cgo_undefined__3 = (secp256k1_ext_reencode_pubkey)*1 }; }
#line 15 "not-num-const"
void __cgo_f_15_4(void) { static const double __cgo_undefined__4 = (secp256k1_ext_reencode_pubkey); }
#line 15 "not-str-lit"
void __cgo_f_15_5(void) { static const char __cgo_undefined__5[] = (secp256k1_ext_reencode_pubkey); }
#line 16 "not-declared"
void __cgo_f_16_1(void) { __typeof__(secp256k1_nonce_function_rfc6979) *__cgo_undefined__1; }
#line 16 "not-type"
void __cgo_f_16_2(void) { secp256k1_nonce_function_rfc6979 *__cgo_undefined__2; }
#line 16 "not-int-const"
void __cgo_f_16_3(void) { enum { __cgo_undefined__3 = (secp256k1_nonce_function_rfc6979)*1 }; }
#line 16 "not-num-const"
void __cgo_f_16_4(void) { static const double __cgo_undefined__4 = (secp256k1_nonce_function_rfc6979); }
#line 16 "not-str-lit"
void __cgo_f_16_5(void) { static const char __cgo_undefined__5[] = (secp256k1_nonce_function_rfc6979); }
#line 17 "not-declared"
void __cgo_f_17_1(void) { __typeof__(size_t) *__cgo_undefined__1; }
#line 17 "not-type"
void __cgo_f_17_2(void) { size_t *__cgo_undefined__2; }
#line 17 "not-int-const"
void __cgo_f_17_3(void) { enum { __cgo_undefined__3 = (size_t)*1 }; }
#line 17 "not-num-const"
void __cgo_f_17_4(void) { static const double __cgo_undefined__4 = (size_t); }
#line 17 "not-str-lit"
void __cgo_f_17_5(void) { static const char __cgo_undefined__5[] = (size_t); }
#line 18 "not-declared"
void __cgo_f_18_1(void) { __typeof__(unsigned char) *__cgo_undefined__1; }
#line 18 "not-type"
void __cgo_f_18_2(void) { unsigned char *__cgo_undefined__2; }
#line 18 "not-int-const"
void __cgo_f_18_3(void) { enum { __cgo_undefined__3 = (unsigned char)*1 }; }
#line 18 "not-num-const"
void __cgo_f_18_4(void) { static const double __cgo_undefined__4 = (unsigned char); }
#line 18 "not-str-lit"
void __cgo_f_18_5(void) { static const char __cgo_undefined__5[] = (unsigned char); }
#line 1 "completed"
int __cgo__1 = __cgo__2;
