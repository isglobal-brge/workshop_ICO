library(DSOpal)
library(dsBaseClient)

# prepare login data and resources to assign
builder <- DSI::newDSLoginBuilder()
builder$append(server = "study1", url = "https://opal-demo.obiba.org", 
               user = "dsuser", password = "P@ssw0rd", 
               resource = "GWAS.ega_phenotypes_1", driver = "OpalDriver")
builder$append(server = "study2", url = "https://opal-demo.obiba.org", 
               user = "dsuser", password = "P@ssw0rd", 
               resource = "GWAS.ega_phenotypes_2", driver = "OpalDriver")
builder$append(server = "study3", url = "https://opal-demo.obiba.org", 
               user = "dsuser", password = "P@ssw0rd", 
               resource = "GWAS.ega_phenotypes_3", driver = "OpalDriver")
logindata <- builder$build()

# login and assign resources
conns <- datashield.login(logins = logindata, assign = TRUE, symbol = "res")

# coerce ResourceClient objects to data.frames
datashield.assign.expr(conns, symbol = "D", 
                       expr = quote(as.resource.data.frame(res, strict = TRUE)))

# Question 1
ds.class("D")


# Question 2
ds.colnames("D")

# Question 3
ds.table("D$sex")
ds.table("D$diabetes_diagnosed_doctor")

# Question 4
ds.table("D$sex", "D$diabetes_diagnosed_doctor")

# Question 5
ds.histogram("D$height", type = "combine")

# Question 6
ds.scatterPlot("D$bmi", "D$weight", type = "combine", datasources = conns)
ds.cor("D$bmi", "D$weight")

# Question 7
ds.glm("cholesterol ~ weight", "D", "gaussian")

# Question 8
ds.asFactor("D$diabetes_diagnosed_doctor", 
            newobj.name = "diab")

ds.glm("diab ~ D$cholesterol", data ="D",
       family = "binomial")

# Question 9
ds.glm("diab ~ cholesterol + bmi", data = "D", 
       family = "binomial")

# Question 10
ds.glm("diab ~ cholesterol * sex + bmi", data = "D", 
       family = "binomial")
# logout the connection !!!
datashield.logout(conns)
