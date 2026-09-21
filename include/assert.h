#ifndef POKEHEARTGOLD_ASSERT_H
#define POKEHEARTGOLD_ASSERT_H

#include "error_handling.h"

/*
 * Assert statements. If the expression evaluates false,
 * the software will terminate.
 *
 * Pass NO_GF_ASSERT=1 to make to remove these.
 */
#ifdef PM_KEEP_ASSERTS
extern u32 gAssertCount;
extern u32 gAssertLine;
extern const char *gAssertFile;
#define GF_ASSERT(expr) ((expr) ? (void)0 : (gAssertCount++, gAssertLine = __LINE__, gAssertFile = __FILE__, GF_AssertFail()))
#else
#define GF_ASSERT(...) ((void)0)
#endif // PM_KEEP_ASSERTS

#endif // POKEHEARTGOLD_ASSERT_H
