This repo houses an extract of GSS cumulative variables on physical and national health from 1972-2022.

The raw GSS cumulative file is located in GSS_stata(1).zip. For any of the R scripts to work, the file should be unzipped on your machine.
Once the file is unzipped, gss-cumulative-clan.R should be able to be run without issue (though check the working directory path to make sure you're telling R to go to the right place on your machine, depending on where you've stored the file.)

Once run, gss-cumulative-clan.R will produce clean-GSS-vars-w-weights.RDS and clean-GSS-vars-w-weights.csv. Those files can then be used to make figures, generate averages and other descriptive statistics, etc.
