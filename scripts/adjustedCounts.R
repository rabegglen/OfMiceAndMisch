## descriptive analysis and Vis

source('./scripts/dataPreparation.R')

## Question to answer here: I need to adjust the counts of behaviours and resources used to animals per cages. (I need t calculate percentages to compare the two groups).

### adjusted counts

Data %>% 
  print()

## for this we need to group by cage

Data %>% 
  group_by(CageNumber) %>% 
  count(AnimalsInCage, Resource, Behaviour)
