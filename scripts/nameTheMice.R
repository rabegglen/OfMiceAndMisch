### Config of the experiment and of the data ###

source('./scripts/dataPreparation.R')



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






