#### simplify the code of Misch ####

# Please see this code as a suggestion to you to make things less complicated and error prone

# Pacman is excellent package management, so you don't have to waste 50 lines of code on calling and installing packages

if(!require(pacman)){
  install.packages('pacman')
}


pacman :: p_load(
  rio,
  epiDisplay,
  vcd,
  MASS,
  patchwork,
  gmodels,
  tidyverse,
  cowplot,
  lubridate,
  randomNames,
  openxlsx,
  install = TRUE
)


# reading data relative to the root directory, which is the directory of the r project

Data = list.files('./data', full.names = TRUE) %>% 
  .[grepl('enrich.+xlsx', ., ignore.case = TRUE)] %>% 
  rio :: import() %>% 
  tibble() %>% ## looks more like a Pandas df.
  
  mutate_all(## do a mutate_all, instead of writing all the cols down to turn the dimensions to factors. You can then change back the other dimensions if needed. Saves you space, code, time and makes your code less prone to errors.
    ., as.factor
  ) %>% 
  
  mutate(
    Date = as.Date(Date), # I'd strongly advise to actually use the date format, if you're working with dates
    Time = as.character(Time), # Parsing the time
    Time = strftime(Time, '%H:%M%:%S'), # Parsing the time
  )


print(Data)


## do some simple checks

# showing the levels of the dimensions in question

for(i in names(Data)){## this will obviously only show you the dimensions, which are actually factors
  
  print(paste('levels of variable:', i))
  
  Data %>% 
    select(i) %>% 
    pull(.) %>%
    levels %>% 
    print()
  
}

# check whether we have any NAs

Data %>% 
  summarise_all(
    ~sum(is.na(.))# you actually don't need to put it into a list
  ) %>% 
  print()





### create IDs and name the mice ###


## how does your data look like? What are the combinations of the things

### What is the config of your experiment?
config = Data %>% 
  select(Cage, CageNumber, Room) %>% 
  distinct() %>% 
  arrange(CageNumber) ## if you look at this data, you see that cage number 13 exists twice. In room 1 and in room 3. Is this intentional, or a mistake?
print(config)



### how many mice do you actually have?

set.seed(420)

mice = Data %>% 
  select(CageNumber, AnimalNumber, Strain, Sex) %>% # Do those dimensions identify your mouse?
  distinct() %>% 
  arrange(CageNumber) %>% 
  mutate(
    
    mouseID = paste0('mouse', 1 : nrow(.)), ## Give your mice some IDs.
    
    mouseName = randomNames(nrow(.), ## you can also give them names alternatively ;-). I mean this is just fun, but maybe worth considering? Genders are even matched ;-).
                            ethnicity = 'hispanic',## because which mouse doesn't want to have a Hispanic name
                            which.names = 'first',
                            sample.with.replacement = FALSE, # No duplicates
                            gender = Sex # Matching the sex of the respective mouse
    )
  )
mice %>% 
  print()

# check whether we have duplicates in the names
mice %>% 
  select(mouseName) %>% 
  distinct()

print(mice)


## let's join the data with the IDs and names back to the original data

Data = Data %>% 
  left_join(
    ., mice, 
    by = c('CageNumber', 'AnimalNumber', 'Strain', 'Sex')
  )



## looks like your mice are numbered by cage, correct? I also count 69 (Nice!) mice in total.
## Now you mentioned that you have 64 mice. Is there a mistake somewhere? Are there duplicates of some sorts?
## It is hard for me to discern whether you have duplicates or not, as I didn't create the data, but I will try to do some things below


## erasing duplicates from your data

Data %>% 
  distinct()# No duplicates if you look at the entries as a whole


## We know that cage number 13 is listed twice. Maybe there is a mistake? We know that we have cages numbered 13 in room 1 and 3

# cage13 = Data %>% 
#   filter(
#     CageNumber == 13 & Room == 1## let's just look at cage number 13 for now. We have 1290 entries
#   )

# cage13 %>% 
#   write.xlsx(., './output/cage13room1.xlsx')

# if we are going to leave out the room number, do we have duplicates?

Data %>% 
  select(-Room) %>% 
  filter(
    CageNumber == 13
  ) %>% 
  distinct() # No


## This honestly makes me believe that you have 69 instead of 64 mice. Please check your data

mice %>% 
  group_by(
    CageNumber
  ) %>% 
  count()











