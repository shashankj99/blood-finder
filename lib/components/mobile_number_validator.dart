class MobileNumberValidator
{
  /*
  * Method to validate mobile number
  * @param String val
  * @return String|null
  */
  String mobileNumberValidator(String val) {
    // set a regex pattern
    Pattern pattern = r'^[0-9]{10}$';

    // instantiate a new regex object with the set pattern
    RegExp _regExp = new RegExp(pattern);

    // return validation error if value doesn't match the pattern
    return (!_regExp.hasMatch(val)) ? 'The Mobile number must be at least 10 digits' : null;
  }
}