library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()

req =  list(
  Inputs = list(
    "input1"= list(
      list(
        'id' = "1",
        'member_id' = "1",
        'loan_amnt' = "1",
        'term' = "36 months",
        'int_rate' = "1",
        'installment' = "1",
        'grade' = "A",
        'sub_grade' = "A1",
        'emp_length' = "10+ years",
        'home_ownership' = "RENT",
        'annual_inc' = "1",
        'is_inc_v' = "Not Verified",
        'loan_status' = "Current",
        'purpose' = "house",
        'addr_state' = "TX",
        'dti' = "1",
        'delinq_2yrs' = "1",
        'earliest_cr_line' = "1",
        'inq_last_6mths' = "1",
        'open_acc' = "1",
        'pub_rec' = "1",
        'revol_bal' = "1",
        'revol_util' = "1",
        'total_acc' = "1",
        'out_prncp' = "1",
        'total_pymnt' = "1",
        'total_rec_prncp' = "1",
        'total_rec_int' = "1",
        'pub_rec_bankruptcies' = "1",
        'tax_liens' = "1"
      )
    )
  ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)

body = enc2utf8(toJSON(req))
api_key = "NeHH1PSWKUQsFspUl+7sjTUHCTgQHWmCy3GNcV30UAOibmb/1Hi2NkIl97mQgpb/od8N1ryohkENQ5jTe545mw==" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/97ac4e49472e428c94edbac1a06de9c0/services/2c9a5b22712e4bf59492a12e13bcbf8f/execute?api-version=2.0&format=swagger",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

print("Result:")
result = h$value()
print(fromJSON(result))