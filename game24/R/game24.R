library(combinat)
library(stringr)






#give every operation a numeric value that will be used inside the function game24.
#a,b are two values that you want to implement operation depending on the value of c.
#for example: num_sign(1,3,1) will return 4, because in this case we calculate 1+3=4
#We have 6 operation in total, because in the case of substruction and division, you have consider their order, so there are two additional operation.
num_sign=function(a,b,sign){
  if(sign==1){
    return(a+b)
  }
  else if(sign==2){
    return(a-b)
  }
  else if(sign==3){
    return(a*b)
  }
  else if(sign==4){
    return(a/b)
  }
  else if(sign==5){
    return(b-a)
  }
  else if(sign==6){
    return(b/a)
  }
}



#function to show the steps of operations that will be used inside the function game24.
#b,c are two values that you want to implement operation depending on the value of c. But, different than the previous function, this one only display the step not the real result.
#this function will return a string that display the step of operation, for example, 
#trans(1,2,4) will return "1 / 2"
#trans(1,2,6) will return "2 / 1"
trans=function(b,c,a){
  stopifnot(a==1 | a==2 | a==3 | a==4 | a==5 | a==6) 
  if(a==1){
    k1=paste("(",b,"+",c,")")
    return(k1)
  }
  else if(a==2){
    k2=paste("(",b,"-",c,")")
    return(k2)
  }
  else if(a==3){
    k3=paste(b,"*",c)
    return(k3)
  }
  else if(a==4){
    k4=paste(b,"/",c)
    return(k4)
  }
  else if(a==5){
    k5=paste("(",c,"-",b,")")
    return(k5)
  }
  else{
    k6=paste(c,"/",b)
    return(k6)
  }
}

#function that transfer characters of signs to numeric
#the S is a character vector that should contain strings of different sign, for example: S=c("+","-")
#this function will return a numeric vector.
#for example : sign(c("+","-")) will return 1,2,5. Note here, there are 3 numeric values, because you have to consider the order of substraction.
sign <- function(S) {
  vector=vector(mode="integer",length=0)#initiate a empty vector 
  for (i in 1:length(S)) { #by the for loop, giving each character in the vector S a numeric value and store each numeric value into new vector 
    if (S[i]=="+") {
      vector=c(vector,1)
    }else if (S[i] == "-") {
      vector=c(vector,2,5)

    }else if (S[i] == "*") {
      vector=c(vector,3)
    }else if (S[i] == "/") {
      vector=c(vector,4,6)
    }
  }
  return(vector)
}
#main function used to calcluate 24 or other interger by selected math operation.

game24=function(A,b=24,Sign=c("+","-","*","/")){
  a<-sign(Sign)#a is the a numeric vector that contains the results from the sign function.
  len=length(A)
  B=combinat::permn(A)
  stopifnot(len==4)# stop if the length of vector A is not 3
  stopifnot(A[1]%%1==0 & A[2]%%1==0 & A[3]%%1==0 & A[4]%%1==0) #stop if any value of vector A is not a integer
  method=vector(mode="character",length=0)#initiate a empty vector 
  operation_1=vector(mode="character",length=0)# a temporary vector of character that stores the the first 2 integer and their way of operation ex:"1/2"
  operation_2=vector(mode="character",length=0)# a temporary vector of character that stores the the first result and third integer and their way of operation ex:"1/2"
  operation_3=vector(mode="character",length=0)# a temporary vector of character that stores the the second result and forth integer and their way of operation ex:"1/2"
  rep=vector(mode="integer",length=0)# 
  result1=vector(mode="integer",length=0)
  result2=vector(mode="integer",length=0)
  for(s in 1:factorial(len)){
    for(i in a){
      result1_temp=num_sign(B[[s]][1],B[[s]][2],i)
      for(j in a){
        result2_temp=num_sign(result1_temp,B[[s]][3],j)
        for(k in a){
          result3=num_sign(result2_temp,B[[s]][4],k)
          if(result3==b){
            operation_1=c(operation_1,trans(B[[s]][1],B[[s]][2],i))
            operation_2=c(operation_2,trans(result1_temp,B[[s]][3],j))
            operation_3=c(operation_3,trans(result2_temp,B[[s]][4],k))
            result1=c(result1,result1_temp)
            result2=c(result2,result2_temp)
          }
        }
      }
    }
  }
  if(length(result1)==0) {

    return(print(paste("You can not get", b))) }


  for(q in 1:(length(result1)-1)){
    s=q+1
    for(p in s:length(result1)){

      if(result1[q]==result1[p]){
        if(result2[q]==result2[p]){
          rep=c(rep,p)
        }
      }
    }
  }
  operation_1=operation_1[-rep]
  operation_2=operation_2[-rep]
  operation_3=operation_3[-rep]
  result1=result1[-rep]
  result2=result2[-rep]

  for(f in 1:length(operation_1)){
    method=c(method,stringr::str_c(operation_1[f]," = ", result1[f], " then ",
                          operation_2[f]," = ", result2[f], " then ",
                          operation_3[f],  " = ",b))
  }

 df=data.frame("Method"=1:length(method),"Process"=method)
 return(df)
}





