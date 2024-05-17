# Unix Command Line and Accessing Cypress 
**An introductory workshop at Tulane University**

[GitHub repository](https://github.com/JessicaMBlanton/CmdLine_and_Cypress_workshop)

Hosted by the department of **[Tropical Medicine and Infectious Disease](https://sph.tulane.edu/trmd/trop-med-is)**. Supported by **[Carl Baribault and the team at Cypress](https://crsc.tulane.edu/)**, Tulane's High Performance Computing System. 

[toc]


## Working at the command line (hour 1)

We are all using BASH (aka Bourne-Again SHell)-flavored command line tools.

Some language to address before we start: 

- Directory = Folder ? Yes.

- Terminal = Console = CLI Shell ? Not by definition, but are often spoken interchangably.
- BASH commands are commonly structured as: 
```bash
[Command] [options] [argument]
```
e.g.
```bash
ls -l cmd_workshop/ 
```
- Hot Tip- one can often "read" basic command calls out loud (the above could be "List, in long format, the contents of the directory cmd_workshop").

- Lastly, this tutorial is predominantly written in commented codeblocks:

    ```
    # This is a comment line, terminal will ignore
    This is a codeblock line, terminal will try to execute
    ```
___


#### Cheat sheets are classic!

[A very nice cheatsheet](https://btiplantbioinfocourse.wordpress.com/wp-content/uploads/2016/02/sgn_unix_commands_cheat_sheet_2016.pdf) from Boyce Thompson Institute (BTI)


#### Getting detailed information about specific commands:

- Computers with full BASH shell installs (MacOS, Linux) have built in manual pages, which can be accessed as:

   ```man [command]```, e.g. ```man pwd```
   
- Otherwise, https://explainshell.com/ is a fantastic yet simple site, where you can type in your command of interest.

### 1. Directory structures and paths


| Command / symbol | Stands for: | Action |
|:--------: |:--------| :--------|
| cd | change directory | changes the working directory |
| pwd | print working directory|prints current location in directory structure to screen|
| ls | list |lists directory contents|
| mkdir| make directory |create a new directory|
| **..**| One level above |dot notation symbol for "up one level"|
| ~| home directory | one of the symbols denoting your home directory|

![directory_structure](https://hackmd.io/_uploads/ByrrfqQmC.jpg)

```bash
# Your "Home" directory is symbolized in a number of ways.
# Move to your home directory using any of these:

cd
cd ~
cd /

# Check the path of your current location 

pwd

# Look at the contents of your location three different ways

ls 
ls -l
ls -F

# Create a directory for this workshop in your home directory

mkdir cmd_workshop/

# Look at your contents again to see your new directory

# Change into your new directory

cd cmd_workshop/

# List this directory's contents

# List the contents of the directory ONE level above

ls ../

# List the contents of the directory TWO levels above

ls ../../

```

### 2. Obtaining workshop data files

| Command / symbol | Stands for: | Action |
|:--------: |:--------| :--------|
| curl | Client for URL | transfers data to and from a server |
| unzip | uncompress ZIP | extract compressed files in a ZIP archive |

Now that we have a bit of experience with directories, let's look at some files.


```bash
# Download workshop files to your new working directory

curl -L -o mammal_data.zip https://github.com/JessicaMBlanton/CmdLine_and_Cypress_workshop/raw/main/mammal_data.zip

# Check that the downloaded archived file is present

# Un-archive the file

unzip mammal_data.zip


# List the contents of the unzipped directory using a relative path

ls mammal_data/


# List the contents of the unzipped directory using an absolute path

ls ~/cmd_workshop/mammal_data/


# Change locations to the this new directory

cd mammal_data/

```
___
#### Detour 1: relative paths are not an absolute 
Check relative vs absolute paths again by using listing contents from this new location. While relative paths are cleaner to look at and easier to type, absolute paths have their advantages too...

```bash
ls mammal_data/

ls ~/cmd_workshop/mammal_data/
```
___


### 3. Examining files

| Command / symbol | Stands for: | Action |
|:--------: |:--------| :--------|
| head | head of file | prints lines at header end of a file |
| tail | tail end of file | prints lines at tail end of a file |
| cat | concatenate | concatenate files and print on the standard output |
| less | "less is more" (a play on historical commands)| allows scrolling forwards and backward through text files, without printing the whole document to screen|
| wc | word count | prints line, word, and byte counts for each file |
| history | history | prints chronological list of previously executed commands |

The data we are working with is a set of gene sequences, inspired by this publication:

Tobe, Shanan S., Andrew C. Kitchener, and Adrian MT Linacre. "Reconstructing mammalian phylogenies: a detailed comparison of the cytochrome b and cytochrome oxidase subunit I mitochondrial genes." PloS one 5.11 (2010): e14156. https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0014156

**Question**: Are humans and other primates more closely related to bunnies or mice? 

**Approach**: Build a gene tree from a *single* marker gene to infer phylogeny of mammals.  

We will tree a subset of these sequences ourselves - the primates, close relatives, and distant relatives (root outgroup)

Let's get a look inside Tobe_2010_mito_ST1.txt using the command line:

```bash
# Print the first (10) lines of the file

head Tobe_2010_mito_ST1.txt


# Print the last (10) lines of the file

tail Tobe_2010_mito_ST1.txt


# Print all lines of the file

cat Tobe_2010_mito_ST1.txt


# Get a scrolling look at the file

less Tobe_2010_mito_ST1.txt
# (exit this by pressing "q")


# Look at the sequence files

head primate_cytb.fna 

head -2 primate_cytb.fna
```

Checking other useful information

```bash
# Count the lines, words, and bytes in one of the .txt files 

wc Tobe_2010_mito_ST1.txt


# Count just the lines

wc -l Tobe_2010_mito_ST1.txt
```

___

#### Detour 2: Flags modify commands
Flags modify the behaviors of commands, and are specifically designated (e.g. the "-l" flag does something entirely different for the ```wc``` versus the ```ls``` command).  What they are and what they mean is found in the manual (```man``` command, or do an online search).

___

#### Detour 3: A taste of wildcards

What if you want to count the lines in *all files* in the current directory at once?
The asterix ```*``` is a wildcard symbol for "any sequence of characters"
This is interpreted as any filename:

```bash
wc -l *
```

Whereas this is interpreted as any filename ending in ".txt" :

```bash
wc -l *.txt
```

___

#### Detour 4: Flatfiles are more universal

The ```mammal_data/``` directory contains many different files.  All but one of them are "flat files" - they have no special formating layers. These can be viewed universally even by very basic text editors. And the command line also has nice tools to explore the shape of these files' contents.
One file is a Microsoft Excel file which can only be read by the Excel program or something built to translate that format.

These two index files contain exactly the same information for the user, but check the results of the ```head``` command:

```bash
head Tobe_2010_mito_ST1.txt

head Tobe_2010_mito_ST1.xlsx
```

Flatfiles (often denoted by .txt, .tsv, .csv) are easy for programs to interpret and easily human-readable. The .xlsx file is coded with layers of formatting that need to be interpreted by Microsoft's Excel program.

*Note- the extension is not what defines a file type*, it's just a useful tag for humans or computer programs to know in advance how to interpret the contents. In fact, the command line itself doesn't pay any attention to the extension at all, which is why it will happily show you gobbly-gook insides of a .xlsx file.

___
**One last thing before we leave for Cypress** -- what commands did we just run? The`history` command is useful to print a record of the commands entered, without the outputs.

```bash
# Print last handful of commands used
history

# Print the last 40 commands used (this flag may not work on some setups)
history -40
```


## Running a job on Cypress (hour 2)
Cypress is the High Performance Computing system at our very own Tulane University. The team there has set up a some nodes in a workshop partition just for us, so that we can jump in and get a taste of what it's like to work on the supercomputer.

Their documentation and workshops extensively cover the details of cypress and it's usage (check out
https://wiki.hpc.tulane.edu/trac/wiki/cypress), so we are simply showing you how you will employ your familiarity with Unix command line to working  remotely.

#### When you log into your cypress account... 
You are now working on a different, remote system.  You chose the [red pill](https://en.wikipedia.org/wiki/Red_pill_and_blue_pill).
Well, anyways, Cypress uses linux. So we can keep using what we've learned... but on a supercomputer!

The diagram below positions how we are interacting with Cypress. When we log in, we are in the log-in nodes, cypress1 or cypress2 (pink rectangles). These are not for doing any heavy computation. But when we submit a job to run, the slurm management system will assign it to the compute nodes (blue rectangles). 

![image](https://hackmd.io/_uploads/rk_3oSXXC.png)
*image source: Tulane hpc workshop materials*



| Command / symbol | Stands for: | Action |
|:--------: |:--------| :--------|
| ssh | Secure Shell | remote login protocol that allows two computers to communicate  |
| scp | Secure Copy | securely copy files between systems through encrypted SSH |
| sbatch |  | submits a batch script to Slurm |
| squeue |  | view information about jobs located in the Slurm scheduling queue |

### 1. Download data directly to Cypress
```bash
# Download exact same workshop files via command line to your home directory

curl -L -o ~/mammal_data.zip https://github.com/JessicaMBlanton/CmdLine_and_Cypress_workshop/raw/main/mammal_data.zip

unzip mammal_data.zip

# Look to see if contents are the expected files
```
### 2. Check and submit a slurm script
Requests from users of Cypress' resources are managed by the [Slurm system](https://slurm.schedmd.com/). It allows users to submit, monitor, and manage jobs with with commands such as ```sbatch``` and ```squeue```.



```bash
# Make sure you are in your home directory!

cd ~


# Download submission script to your home directory

curl -L -o ~/ptree_submit.sh https://raw.githubusercontent.com/JessicaMBlanton/CmdLine_and_Cypress_workshop/main/ptree_submit.sh


# Let's examine this script

cat ptree_submit.sh
```
In the script downloaded here, there are a number of important elements for how it was constructed.

![slurm_anatomy](https://hackmd.io/_uploads/B1RIRzVXR.jpg)

```bash
# Submit this batch script!

sbatch ptree_submit.sh

# The slurm manager will respond with a job ID 
# e.g. "Submitted batch job 2527931"


# Monitor the running jobs

squeue


# Limit squeue to just your username

squeue -u tuhpc022


# Limit squeue to exactly your job ID

squeue -j 2527931
```



If the script executes successfully, you will have a new directory, with 4 files inside, the alignment + logfile, and the built tree + logfile

* primate_tree/aln.fna
* primate_tree/muscle_aln.log
* primate_tree/p_tree.nwk
* primate_tree/fasttree.log

Additionally, you have a files for other output that would have printed to your terminal window if you had run these commands locally:
* p_tree.out
* p_tree.err

### 3. Bringing the output home

In a new terminal window (that is not logged into Cypress), copy the ouput, especially the newick tree file back to your local computer.


```bash
# Copy output files to your computer 
# Use the "-r" flag, which will download the whole directory

# Unix terminal uses forward slashes in destination path
scp -r [YourUserID]@cypress.tulane.edu:/home/workshop/[YourUserID]/primate_tree/ ~/cmd_workshop/


# Windows command prompt or powershell uses back slashes in destination path
scp -r [YourUserID]@cypress.tulane.edu:/home/workshop/[YourUserID]/primate_tree/ ~\cmd_workshop\

```
If scp is still not working for you, but you are eager to see the expected results, download previously-run output from github:

```bash
curl -L -o primate_tree_output.zip https://github.com/JessicaMBlanton/CmdLine_and_Cypress_workshop/raw/main/primate_tree_output.zip

unzip primate_tree_output.zip

ls primate_tree/
```

### 4. Getting back to our research question for this dataset
(Who are the closest phylogenetic siblings to Primates - Bunnies or Rodents?)

View the newick tree (p_tree.nwk) in any tree-viewing software. This website is great for rendering tree-files: https://phylo.io/

1. Root your tree on the the Monotreme branch (basal mammals platypus and echidna)
2. Where does the *cytochrome B* gene tree place Lagomorphs (e.g. bunnies) and Rodentia (e.g. mice) in relation to primates?
3. Do the relationships you might expect within the primates hold true in this gene tree?


## Wishlist additions to future iterations of this tutorial

1. ==R example for cypress==
1. ==Further online class resources==
1. ==example use case for command line big data handling==
1. ==example sequence retrival and formatting commands==
1. ==nano for text editing==
1. ==Tutorial wishlist detour:check permissions on script==
```bash
# Is your script executable?
ls -l ptree_submit.sh
```
7. ==Tutorial wishlist detour: explain modules==
```bash
# Check what is already installed by the sys admins

module avail
```

___
