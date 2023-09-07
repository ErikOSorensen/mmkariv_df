// Doing all file reading in sequence for publishing data


do scripts/read_tanzania_survey.do
do scripts/read_decisions.do
do scripts/read_iqs.do
do scripts/read_big5.do
do scripts/read_others.do
do scripts/read_questions.do
do scripts/merge_background.do
cp processed/studysubjects_categorized.csv data/
