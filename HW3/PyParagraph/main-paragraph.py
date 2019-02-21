# This code reads a text file and write the Word Count data including
# The number of paragraphs, Total number of words, words and letters per paragraph, 
# average word per sentence per paragraph, and average sentence length per paragraph.
# MMB- 022119
import re
import sys
from importlib import reload
#reload(sys).setdefaultencoding("ISO-8859-1")
#textfile='paragraph-text.txt'
textfile= 'Hunters wife_story.txt'
file = open('results_Word_Count_from_'+textfile,'w') 
with open(textfile,'r') as paragraphs:
    #"str.decode('utf-8',errors='ignore')
    All_parags=paragraphs.readlines()

    Total_words=0
    Total_letters=0
    for par_no in range(len(All_parags)):

        file.write('\n\n------------------------ Paragraph # %i -----------------------------\n\n' %(par_no+1))
        each_par=All_parags[par_no]
        each_par=each_par.replace('"','')

        sentence_count=each_par.split(".")

        #Sum_words=sum(len(Word_count[i]) for i in len(Word_count))
        Word_count=each_par.split() 
        file.write('# %i : Apprixmate Word Count:  %i\n' % ((par_no+1), len(Word_count)))

        file.write('# %i : Apprixmate Sentence Count: %i\n' % ((par_no+1), (len(sentence_count)-1)))
        # A=re.split("(?<=[.!?]) +", paragraph)
        letter_count=0
        for i in range(len(Word_count)):
            letter_count += len(Word_count[i])
            #print("word#", i, " : ", Word_count[i], '  letters number: ', len(Word_count[i]), ' total letters: ', letter_count)
        #print('---------------------------- next sentence------------------------------------------')
        #Sum_words=sum(len(Word_count[i]) for i in len(Word_count))
        Letter_avg=letter_count/len(Word_count)
        file.write('# %i : Average Letter Count: %.1f\n' %((par_no+1),Letter_avg))
        if len(sentence_count)>1:
            Word_avg=len(Word_count)/(len(sentence_count)-1)
        else:
            Word_avg=len(Word_count)

        file.write('# %i : Average Sentence Length: %.1f\n' % ((par_no+1),Word_avg))
        Total_words +=  len(Word_count)
        Total_letters += letter_count

    file.write("\n------------------------ TOTAL Report -------------------------------\n\n")
    file.write('Total: Apprixmate Word Count: %i\n' %Total_words)
    file.write('Total: Approximate Letter Count:  %i\n' %Total_letters)
    file.write("\n------------------------ End of Report -------------------------------\n\n")  
    file.close()