// Doing all file reading in sequence for publishing data

do read_tanzania_survey.do
do read_decisions.do
do read_iqs.do
do read_big5.do
do read_others.do
do read_questions.do
do merge_background.do
