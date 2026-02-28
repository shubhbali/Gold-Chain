#include <stddef.h>
int main(int argc __attribute__((unused)), char **argv __attribute__((unused))) { return 0; }
void crosscall2(void(*fn)(void*) __attribute__((unused)), void *a __attribute__((unused)), int c __attribute__((unused)), size_t ctxt __attribute__((unused))) { }
size_t _cgo_wait_runtime_init_done(void) { return 0; }
void _cgo_release_context(size_t ctxt __attribute__((unused))) { }
char* _cgo_topofstack(void) { return (char*)0; }
void _cgo_allocate(void *a __attribute__((unused)), int c __attribute__((unused))) { }
void _cgo_panic(void *a __attribute__((unused)), int c __attribute__((unused))) { }
void _cgo_reginit(void) { }
#line 1 "cgo-generated-wrappers"
extern void secp256k1GoPanicError();
extern void secp256k1GoPanicIllegal();
extern char secp256k1_nonce_function_rfc6979[];
void *_cgohack_secp256k1_nonce_function_rfc6979 = secp256k1_nonce_function_rfc6979;

void _cgoexp_1fc93ead4968_secp256k1GoPanicIllegal(void* p __attribute__((unused))){}
void _cgoexp_1fc93ead4968_secp256k1GoPanicError(void* p __attribute__((unused))){}
