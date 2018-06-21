#
gap> Read(Filename(DirectoriesPackageLibrary("walrus", "tst"), "testexamples.g"));

# 
gap> Read(Filename(DirectoriesPackageLibrary("walrus", "tst"), "F2.out"));
gap> TestExampleList(pg2, ConvertWordFreeGroup, rgreens2{[1..20]}, results2{[1..20]}, 1/100, false);
testing: 1...done: true
testing: 2...done: false
testing: 3...done: false
testing: 4...done: true
testing: 5...done: true
testing: 6...done: true
testing: 7...done: true
testing: 8...done: true
testing: 9...done: true
testing: 10...done: true
testing: 11...done: true
testing: 12...done: false
testing: 13...done: false
testing: 14...done: false
testing: 15...done: false
testing: 16...done: true
testing: 17...done: true
testing: 18...done: true
testing: 19...done: true
testing: 20...done: true
[ true, false, false, true, true, true, true, true, true, true, true, false, 
  false, false, false, true, true, true, true, true ]

#
gap> Read(Filename(DirectoriesPackageLibrary("walrus", "tst"), "F20.out"));
gap> TestExampleList(pg20, ConvertWordFreeGroup, rgreens20{[1..40]}, results20{[1..40]}, 1/100, false);
testing: 1...done: true
testing: 2...done: true
testing: 3...done: true
testing: 4...done: true
testing: 5...done: true
testing: 6...done: false
testing: 7...done: true
testing: 8...done: false
testing: 9...done: false
testing: 10...done: false
testing: 11...done: false
testing: 12...done: true
testing: 13...done: true
testing: 14...done: true
testing: 15...done: false
testing: 16...done: true
testing: 17...done: true
testing: 18...done: false
testing: 19...done: false
testing: 20...done: false
testing: 21...done: false
testing: 22...done: true
testing: 23...done: false
testing: 24...done: true
testing: 25...done: true
testing: 26...done: true
testing: 27...done: true
testing: 28...done: true
testing: 29...done: false
testing: 30...done: false
testing: 31...done: true
testing: 32...done: true
testing: 33...done: false
testing: 34...done: true
testing: 35...done: false
testing: 36...done: true
testing: 37...done: false
testing: 38...done: false
testing: 39...done: true
testing: 40...done: true
[ true, true, true, true, true, false, true, false, false, false, false, 
  true, true, true, false, true, true, false, false, false, false, true, 
  false, true, true, true, true, true, false, false, true, true, false, true, 
  false, true, false, false, true, true ]

#
gap> Read(Filename(DirectoriesPackageLibrary("walrus", "tst"), "psl.out"));
gap> TestExampleList(pg_psl, ConvertWordPSL, rgreenspsl{ [1..10] }, results_psl{ [1..10] }, 1/100, false);
testing: 1...done: true
testing: 2...done: true
testing: 3...done: true
testing: 4...done: false
testing: 5...done: false
testing: 6...done: true
testing: 7...done: true
testing: 8...done: false
testing: 9...done: true
testing: 10...done: true
[ true, true, true, false, false, true, true, false, true, true ]

#
gap> Read(Filename(DirectoriesPackageLibrary("walrus", "tst"), "s3s3.out"));
gap> TestExampleList(pg_s3s3, ConvertWordS3S3, rgreenS3S3{ [1..20] }, resS3S3{ [1..20] }, 1/100, false);
testing: 1...done: false
testing: 2...done: true
testing: 3...done: false
testing: 4...done: false
testing: 5...done: true
testing: 6...done: true
testing: 7...done: false
testing: 8...done: true
testing: 9...done: false
testing: 10...done: false
testing: 11...done: false
testing: 12...done: true
testing: 13...done: true
testing: 14...done: false
testing: 15...done: false
testing: 16...done: true
testing: 17...done: true
testing: 18...done: true
testing: 19...done: false
testing: 20...done: true
[ false, true, false, false, true, true, false, true, false, false, false, 
  true, true, false, false, true, true, true, false, true ]

#
