Feature: To Test the Create Lead API for Four wheeler online Flow

  Background: Setting the data for the create lead API
    * url 'https://mv-preprod.gromoinsure.in'
    * path '/api/v1/insurance/lead/create'
    * header Authorization = 'eItk7j0aOYpC4NV16Gkb8EYhoWBL2tFRO6lWohd1wkKkfWdIaV6hMBtChpJGD%2BRfEsKuPFIc8Um%2F3o%2BeBq6j5QG2m2FUM5LZkXKkebAiaIbSAajH%2Ffc%2F0TUVj9%2BF8E8l3ZPUv4zdvruZt7uBIwxlH4EZ%2Ftkk2wncFmGAsCSkURybVH%2Be8inoUiWoR2Cn2frI5e%2Fn5ms66XZeoqOiqrWKvoSzvZFEfzJZAr05zYKVu47vx%2BhEh8pggJWXjAcxjNNlAgqEkrPjdmRZL4w4GHy3HyRKnci0MMZMY%2FRhgUFHH3F3iI5G4mWgsxvmPH8iPYlyxNVngNaoLAhRhbDtD9EVI1zzo69U3eDx83p4p%2FCaHXPWHKt2PfxLiZvrnjJnWrTJ3T6i%2FxKOLasoX%2FhqN0jvxZf7w3HoSs6GQvLvO9ky0efVMVO2Tl2M3MBmzcZWUchBi0XenD3hBM%2FxzYKgv8lC9nhQ0XiQje0L47j0tTbaCBETiXFO4W1qjObM3XY03wV11xnH5zBe5qpu9BYeh1d%2F%2FjYqYl67YtH3Br51vN1OGyV5Pbw3itHMqoX%2FCM%2FQ0d2OGDa8emw6VYJpPveqfLwAfoMs%2B0BTz%2BZBcE9rd5uFOEMkoHs17a%2FX4gCev6dBgRAOtIfF6T5hGn4qftz3LP2%2Fq0qX7L1pSL1u3Ca%2FdRI1q6I%3D'
    * header userid = '7FNS2221'

  # HHTP Method Validations
  Scenario Outline: To validate create lead api with invalid methods - <method>
    * def errorResponse = read('../404ErrorSchema.json')
    Given request {}
    And method <method>
    When status 404
    And print response
    Then match response == errorResponse[<index>]
    And print errorResponse[<index>]
    Examples: 
      | method | index |
      | get    |     0 |
      | patch  |     1 |
      | put    |     2 |

  #Happy flow for the API and response schema validation
  Scenario Outline: Validate Create Lead API with valid accessToken for Posp user with vehicle number - <registrationNumber>
    * def actualResponse = read('../createLeadResponseschema.json')
    Given request {  "registrationNumber": '#(registrationNumber)',"businessType": '#(businessType)', "insurancePolicySubType": '#(insurancePolicySubType)' }
    And headers {Accept : 'application/json', Content-Type: 'application/json', isPos:'true', userid: '7FNS2221' }
    When method post
    And match response == actualResponse
    Then status <status>
    

    Examples: 
      | registrationNumber | businessType | insurancePolicySubType | status |
      | HR26AG2024         | car          | new                    |    200 |
      | gfhjfhjfhj         | car          | rollover               |    400 |

  #Data driven aproach by reading request from csv file(request manipulation)
  Scenario Outline: Data Driven for the create lead api for vehicle number - <registrationNumber>
  Given request {  "registrationNumber": '#(registrationNumber)',"businessType": '#(businessType)', "insurancePolicySubType": '#(insurancePolicySubType)' }
  And headers {Accept : 'application/json', Content-Type: 'application/json', isPos:'true', userid: '7FNS2221' }
  When method post
  Then status <status>
  
  Examples:
  | read("testData.csv") |
  
  #Request Header manipulation
  Scenario Outline: Validate Create Lead API with manipulating the headers
  * def errorResponse = read('../createLead400ErrorSchema.json')
    Given request {  "registrationNumber": '#(registrationNumber)',"businessType": '#(businessType)', "insurancePolicySubType": '#(insurancePolicySubType)' }
    And headers {Accept : 'application/json', Content-Type: 'application/json', isPos:'<pos>', userid: '<userid>' } # Replace <userid> with the manipulated value
    When method post
    Then status <status>
    And print response
    And match response == errorResponse
    
    Examples: 
      | registrationNumber | businessType | insurancePolicySubType | status | userid     | pos  |
      | HR26AG2024         | car          | new                    |    400 | abcd       | false|
      | HR26AG2024         | car          | new                    |    400 | 7FNS2221   | false|
      | HR26AG2024         | car          | new                    |    400 | 7FNS2221   | true |
