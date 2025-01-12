/*
** The table [BufferSizes] is used by the SSIS package to dynamically run different scenarios 
** with different buffer sizes.
** Modify this file to setup different buffersizes you would like to test.
** For testing your setup it is recommended to use only one buffersize.
*/
TRUNCATE TABLE BufferSizes
INSERT INTO BufferSizes (BufferSize)
/*Test setup*/
VALUES  (100000)
/*Most performing scenarios*/
--VALUES (1000), (10000), (100000), (120000), (150000), (199000), (200000)
/*Full test scenarios*/
--VALUES (1000), (10000), (100000), (120000), (150000), (199000), (200000), (300000), (400000)

