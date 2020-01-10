## Test environments
* local OS X install, R 3.6.2
* ubuntu 16.04.6 (on travis-ci), R 3.6.2
* Debian GNU/Linux 9 (on Docker)
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* Reduced test and example demonstration code to reduce execution time.
* checking data for non-ASCII characters ... found 47 marked UTF-8 strings
* The note refers to mis-spelled words. One of this word is Kanji which used in the Japanese writing system.

```
Possibly mis-spelled words in DESCRIPTION:
     Kanji
```
