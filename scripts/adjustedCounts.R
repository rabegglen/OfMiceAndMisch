## descriptive analysis and Vis

source('./scripts/dataPreparation.R')

## Question to answer here: I need to adjust the counts of behaviours and resources used to animals per cages. (I need t calculate percentages to compare the two groups).
## --> you sure you want to have percentages? For adjusted counts see below


### adjusted counts

Data %>% 
  print()

## for this we need to group by cage

ResourceBehaviourCount = Data %>% 
  group_by(CageNumber, AnimalsInCage, Sex, Strain, Coder) %>% ### if you group_by, it will group by the parameter with the highest resolution - here it's cage number. You can imagine it as the parameter with the highest hierarchy. If you take cage number, there are only multiple of the other parameters.
  count(Resource, Behaviour) %>% 
  ungroup() %>% 
  mutate(
    AnimalsInCage = as.character(AnimalsInCage),
    AnimalsInCage = as.numeric(AnimalsInCage),
    adjustedRB = (n / AnimalsInCage)
    
  )

ResourceCount = Data %>% 
  group_by(CageNumber, AnimalsInCage, Sex, Strain, Coder) %>%
  count(Resource) %>%
  ungroup() %>% 
  mutate(
    AnimalsInCage = as.character(AnimalsInCage),
    AnimalsInCage = as.numeric(AnimalsInCage),
    adjustedRB = (n / AnimalsInCage)
    
  )


BehaviourCount = Data %>% 
  group_by(CageNumber, AnimalsInCage, Sex, Strain, Coder) %>%
  count(Behaviour) %>% 
  ungroup() %>% 
  mutate(
    AnimalsInCage = as.character(AnimalsInCage),
    AnimalsInCage = as.numeric(AnimalsInCage),
    adjustedRB = (n / AnimalsInCage)
    
  )