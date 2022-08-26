#### the stats ####

source('./scripts/dataPreparation.R')
source('./scripts/adjustedCounts.R')


## for the stats I would start out simple

## let's see how it works for  adjusted values for behaviours
## if I were you, I'd cast the data accross behaviours, so that the data goes from long to wide. Long is handy in a technical sense, but is easier for stats.
# First, check for normality:

stats = BehaviourCount %>% 
  select(-n) %>% 
  as.data.table() %>% 
  dcast(., 
    CageNumber + AnimalsInCage + Sex + Strain + Coder ~ Behaviour,
    value.var = 'adjustedRB'
  ) %>% 
  tibble()


## let's loop through this to get a quick overview

# get all the behaviours into one vector

behaviours = BehaviourCount$Behaviour %>% as.character() %>% unique()

# push it all through a loop
for(i in behaviours){
  
  vector = stats[[i]] 
  
  result = shapiro.test(vector)
  print(i)
  print(result)
  
  
}

# here we see that 'feeding' is normally distributed, so it qualifies for a simple t-test

t.test(Feeding ~ Strain, data = stats)# here you can see that both strains do not differ in feeding behaviour
t.test(Grooming ~ Strain, data = stats)# here you can see that there is a difference in grooming behaviour

# After that you can also use simple linear regressions if the residuals are normally distributed or you can even use linear mixed effect models