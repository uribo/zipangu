## Test environments
* local OS X install, R 4.0.3
* ubuntu 20.04 LTS (on docker), R 4.0.3
* win-builder (devel and release)
* R-hub builder

## R CMD check results

0 errors | 0 warnings | 1 note

* checking data for non-ASCII characters ... found 47 marked UTF-8 strings
* The note refers to miss-spelled words. One of this word is Kanji which used in the Japanese writing system.

```
Possibly mis-spelled words in DESCRIPTION:
     Kanji
```

* Days since last update: 5. This is because the raw data used in the package was found to be incorrect and needed to be patched.
