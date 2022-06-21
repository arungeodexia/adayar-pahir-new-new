class AppStrings {
  //--------------------------------------------------- General -----------------------------------------------------------------------------------------

  static const String APP_NAME = "Adyar Cancer Institute";
  static const String SEARCH_RESOURCE = "Search Skill";
  static const String BASE_URL = DEV_URL;
  
  //static const String DEV_URL = "http://ishare-dev.us-east-1.elasticbeanstalk.com/"; //Old 
  //static const String DEV_URL = "https://www.pahir.com/"; //Current - Master / Phase-1 Url
  static const String DEV_URL = "https://api.aci.pahir.com/"; //Current - Master / Phase-1 Url
  //static const String DEV_URL = "http://pahirphase2-env.eba-38dsipeh.us-east-1.elasticbeanstalk.com/"; // Phase-2 Url

  // static const String DEV_URL = "http://ishare-new.us-east-1.elasticbeanstalk.com/";
  static const String STAGE_URL = "";
  static const String PROD_URL = "";
  static String WHATSAPP_ERROR="WhatsApp not installed! ";
  static String VIDEO ="Video";
  static String PDF_VIWER="Pdf Viewer";
  static String TOTAL_MATCHES ="Total Matches : ";



  //--------------------------------------------------- Messages -----------------------------------------------------------------------------------------

  static String APP_MESSAGES_TITLE="Messages";
  //--------------------------------------------------- Welcome screen -----------------------------------------------------------------------------------------
  static String WELCOME_CHECK_NETWORK_CONN="Check network connection and retry";
  static String WELCOME_SYS_ERROR="System error. Try again.";
  static String WELCOME_SERVER_TEMP_NOT_REACHABLE="Server temporarily not reachable. Try again.";
  static String WELCOME_CONTACT_NOT_AVAIL="Contact is not available";
  //static String WELCOME_UPDATE_CONTACT_MSG="  ACI is currently processing contacts.\n It make take few seconds. Do not quit.  ";
  static String WELCOME_UPDATE_CONTACT_MSG="  Checking other ACI users in your network. Please be patient.  ";
  static String LOADING_MSG="Loading..";
  
  //--------------------------------------------------- Login -----------------------------------------------------------------------------------------

  static const String LOGIN_INIT_SIGNIN = "Sign in";
  static const String LOGIN_INIT_SIGNUP = "Sign up";
  static const String LOGIN_INIT_TITLE_TEXT = "Protect your loved ones. Find vacant beds, oxygen supplies, vaccination centers, ambulances and other important contact informations. Let us know what you need, and where, we will reach you when they are available near you. Let’s fight germs  together!";
//--------------------------------------------------- Contact Sync -----------------------------------------------------------------------------------------
static const String CONTACT_SYNC_TITLE = "Sync Contacts";
static const String CONTACT_SYNC_SUCCESSFULLY = "Contacts Synced Sucessfully";

//--------------------------------------------------- Signup Mobile -----------------------------------------------------------------------------------------

  static const String SIGNUP_MOBILE_CONTINUE_BT_LBL = "Agree & Continue";
  static const String SIGNUP_MOBILE_ENTER_PHNO_TITLE =
      "Enter your phone number";
  static const String SIGNUP_MOBILE_ENTER_PHNO_TITLE_DESC =
      "ACI will send an SMS message to verify your phone number (carrier charges may apply).";

  static const String SIGNUP_MOBILE_ENTER_PHNO_TF_LABEL =
      "Enter your phone number";

  static const String SIGNUP_MOBILE_ENTER_PHNO_TF_HINT = "(123) 456 7890";

  static const String SIGNUP_MOBILE_ENTER_CC_TF_HINT = "+1";

  static const String SIGNUP_MOBILE_ENTER_PHNO_LBL_TERMS_TITLE =
      "By creating an account you agree to our ";

  static const String SIGNUP_MOBILE_ENTER_PHNO_LBL_TERMS_LINK =
      "Terms of Service and Privacy Policy";

  static const String SIGNUP_MOBILE_ENTER_PHNO_LBL_TERMS_URL =
    //  "https://s3.amazonaws.com/dailywagers-terms/Terms-and-conditions.html";
      "https://ishare-public.s3.amazonaws.com/live/ACITermsandConditions.html";

//--------------------------------------------------- Signup Otp -----------------------------------------------------------------------------------------

  static const String SIGNUP_OTP_VERIFY_BT_LBL = "Verify";

  static const String SIGNUP_OTP_ENTER_OTP_TITLE = "Verify +1 (123) 456 7890";
  static const String SIGNUP_OTP_ENTER_OTP_DESC = "Waiting to automatically detect an SMS sent to your phone number ";

  static const String SIGNUP_OTP_ENTER_OTP_TITLE_DESC =
      "Waiting to automatically detect an SMS sent to your phone number";

  static const String SIGNUP_OTP_ENTER_RESEND = " Resend SMS";

  static const String SIGNUP_OTP_ENTER_CALLME = "Call me";

  static const String SIGNUP_OTP_ENTER_OTP_CHARACTERS = "Enter 6-digit code";

  static const String SIGNUP_OTP_ENTER_WRONG_NUMBER = "Wrong Number?";


  //--------------------------------------------------- Signin -----------------------------------------------------------------------------------------

  static const String SIGNIN_CONTINUE_BT_LBL = "Continue";
  static const String SIGNIN_TITLE = "Welcome Back.";
  static const String SIGNIN_SUB_TITLE = "What is your phone number?";
  static const String SIGNIN_QUESTION = "Why do we ask?";

//--------------------------------------------------- Create Profile -----------------------------------------------------------------------------------------

  static const String CREATE_PROFILE_TITLE = "Create Profile";
  static const String CREATE_PROFILE_FULLNAME_HINT = "Jane Doe";
  static const String CREATE_PROFILE_FULLNAME_LABEL = "Full Name *";
   static const String CREATE_PROFILE_PROVIDE_SERVICE_LABEL = "I Provide Service ";

  static const String CREATE_PROFILE_SKILL_HINT = "Select skill";
  static const String CREATE_PROFILE_SKILL_LABEL = "Skill";

  static const String CREATE_PROFILE_MOBILENUMBER_HINT = "+1 (123) 456 7890";
  static const String CREATE_PROFILE_MOBILENUMBER_LABEL = "Mobile";

  static const String CREATE_PROFILE_ALTERNATE_NUMBER_HINT =
      "+1 (123) 456 7890";
  static const String CREATE_PROFILE_ALTERNATE_NUMBER_LABEL =
      "Alternate Number  ";
 static const String CREATE_PROFILE_CITY_LABEL =
      "City";
  static const String CREATE_PROFILE_CITY_HINT =
  "e.g Coimbatore";

  static const String CREATE_PROFILE_STATE_LABEL =
      "State";
  static const String CREATE_PROFILE_STATE_HINT =
  "e.g California";



  static const String CREATE_PROFILE_EMAIL_HINT = "email@somedomain.com";
  static const String CREATE_PROFILE_EMAIL_LABEL = "Email  ";

  static const String CREATE_PROFILE_NOTES_HINT =
      "Enter notes";
  static const String CREATE_PROFILE_NOTES_LABEL = "Notes  ";

 // static const String CREATE_PROFILE_SAVE_BT_LBL = "Save Profile";
  static const String CREATE_PROFILE_SAVE_BT_LBL = "Profile Saved";

static const String ENTER_EMAIL_ID = "Enter Email id";
static const String INVALID_EMAIL_ID = "Invalid Email id";




  //--------------------------------------------------- Update Mobile -----------------------------------------------------------------------------------------

  static const String UPDATE_MOBILE_TITLE = "Update Phone Number";
 // static const String UPDATE_MOBILE_CONTINUE_BT_LBL = "Confirm and Update";
  static const String UPDATE_MOBILE_CONTINUE_BT_LBL = "Profile Updated";
  static const String UPDATE_MOBILE_SUBMIT_BT_LBL = "Submit";
  static const String UPDATE_MOBILE_ENTER_PHNO_TITLE =
      "Update your phone number";
  static const String UPDATE_MOBILE_ENTER_PHNO_TITLE_DESC =
      "ACI will send an SMS message to verify your phone number (carrier charges may apply). Enter your country code and phone number";




//--------------------------------------------------- Reviews List -----------------------------------------------------------------------------------------
  static const String REVIEWS_LIST_TITLE = "Reviews";
  static const String REVIEWS_LIST_REVIEWERS_NOT_FOUND = "Reviewer(s) Not Found";
  static const String REVIEWS_LIST_REVIEWER_NOT_FOUND = "Reviewer Data Not Found";
  static const String REVIEWS_LIST_MORE = "...more";
//--------------------------------------------------- Edit Profile -----------------------------------------------------------------------------------------

  static const String EDIT_PROFILE_TITLE = "Update Profile";
  static const String EDIT_PROFILE_FULLNAME_HINT = "Jane Doe";
  static const String EDIT_PROFILE_FULLNAME_LABEL = "Full Name";

  static const String EDIT_PROFILE_SKILL_HINT = "Select skill";
  static const String EDIT_PROFILE_SKILL_LABEL = "Skill";

  static const String EDIT_PROFILE_MOBILENUMBER_HINT = "+1(123)456 7890";
  static const String EDIT_PROFILE_MOBILENUMBER_LABEL = "Mobile";

  static const String EDIT_PROFILE_ALTERNATE_NUMBER_HINT = "+1(123)456 7890";
  static const String EDIT_PROFILE_ALTERNATE_NUMBER_LABEL =
      "Alternate Number  ";

  static const String EDIT_PROFILE_EMAIL_HINT = "email@sumdomain.com";
  static const String EDIT_PROFILE_EMAIL_LABEL = "Email  ";

  static const String EDIT_PROFILE_NOTES_HINT =
      "Enter notes";
  static const String EDIT_PROFILE_NOTES_LABEL = "Notes  ";
  static const String MORE_SKILL_LABEL = "More Skills  ";
  static const String REVIEWS_LABEL = "Review ";

  static const String EDIT_PROFILE_SWITCH_LABEL = "Switch to User Account";

  static const String EDIT_PROFILE_UPDATE_BT_LBL = "Update Profile";

  static const String EDIT_PROFILE_DIAG_SUCCESS_TITLE = "Success";
  static const String EDIT_PROFILE_DIAG_SUCCESS_CONTENT = "Profile is succesfully updated!";
  static const String EDIT_PROFILE_SUCCESS_BT_LBL = "Ok";
  static const String EDIT_PROFILE_DIAG_FAILURE_TITLE = "Failure";
  static const String EDIT_PROFILE_DIAG_FAILURE_CONTENT = "profile is not updated!";
  static const String EDIT_PROFILE_DIAG_FAILURE_BT_LBL = "Ok";

 static const String EDIT_PROFILE_CHANG_DIAG_TITLE = "Alert"; 
 static const String EDIT_PROFILE_CHANG_DIAG_CONTENT = "Changes made will be discarded"; 
 static const String EDIT_PROFILE_CHANG_DIAG_OK = "OK"; 
 static const String EDIT_PROFILE_CHANG_DIAG_CANCEL = "CANCEL"; 
  //--------------------------------------------------- Add New Resource -----------------------------------------------------------------------------------------

  static const String ADD_NEW_RESOURCE_TITLE = "Add Resource";

  static const String ADD_NEW_RESOURCE_PICK_CONTACT_LINK =
      "+ Add Resource from your Contacts";

  static const String ADD_NEW_RESOURCE_FULLNAME_HINT = "Jane Doe";
  static const String ADD_NEW_RESOURCE_FULLNAME_LABEL = "Full Name";

  static const String ADD_NEW_RESOURCE_SKILL_HINT = "Select Skill";
  static const String ADD_NEW_RESOURCE_SKILL_LABEL = "Skill";

  static const String ADD_NEW_RESOURCE_MOBILENUMBER_HINT = "+1(123)456 7890";
  static const String ADD_NEW_RESOURCE_MOBILENUMBER_LABEL = "Mobile";

  static const String ADD_NEW_RESOURCE_ALTERNATE_NUMBER_HINT =
      "+1(123)456 7890";
  static const String ADD_NEW_RESOURCE_ALTERNATE_NUMBER_LABEL =
      "Alternate Number  ";

  static const String ADD_NEW_RESOURCE_EMAIL_HINT = "email@sumdomain.com";
  static const String ADD_NEW_RESOURCE_EMAIL_LABEL = "Email  ";

  static const String ADD_NEW_RESOURCE_RATING_LABEL = "Rating";

  static const String ADD_NEW_RESOURCE_NOTES_HINT =
      "Enter notes";
   static const String MORE_SKILL_HINT = "e.g. Landscaping, Moving";
  static const String ADD_NEW_RESOURCE_NOTES_LABEL = "Notes  ";
  static const String REVIEW_HINT = "Review";

  static const String ADD_NEW_RESOURCE_SAVE_BT_LBL = "Add Resource";
static const String UPDATE_RESOURCE_SAVE_BT_LBL = "Update Resource";
  static const String ADD_NEW_RESOURCE_DIAG_SUCCESS_TITLE = "Success";
  static const String ADD_NEW_RESOURCE_DIAG_SUCCESS_CONTENT = "Resource is succesfully added!";
  static const String UPDATE_RESOURCE_DIAG_SUCCESS_CONTENT = "Resource is succesfully Updated!";
  static const String ADD_NEW_RESOURCE_DIAG_SUCCESS_BT_LBL = "Ok";
  static const String ADD_NEW_RESOURCE_DIAG_FAILURE_TITLE = "Failure";
  static const String ADD_NEW_RESOURCE_DIAG_FAILURE_CONTENT = "Resource adding failed!";
  static const String UPDATE_RESOURCE_DIAG_FAILURE_CONTENT = "Resource updating failed!";
  static const String ADD_NEW_RESOURCE_DIAG_FAILURE_BT_LBL = "Ok";

  static const String ADD_NEW_RESOURCE_CITY_LABEL =
      "City  ";
  static const String ADD_NEW_RESOURCE_CITY_HINT =
  "e.g San diego";

  static const String ADD_NEW_RESOURCE_STATE_LABEL =
      "State  ";
  static const String ADD_NEW_RESOURCE_STATE_HINT =
  "e.g California";

//--------------------------------------------------- Choose Profile -----------------------------------------------------------------------------------------

  static const String CHOOSE_PROFILE_TYPE_TITLE = "Choose your profile type";

  static const String CHOOSE_PROFILE_TYPE_SUB_TITLE = "Please choose one:";

  static const String CHOOSE_PROFILE_TYPE_RESOURCE_TITLE = "Service Provider";

  static const String CHOOSE_PROFILE_TYPE_RESOURCE_CONTENT =
      "I offer services to ACI users.";

  static const String CHOOSE_PROFILE_TYPE_SERVICE_TITLE = "User";

  static const String CHOOSE_PROFILE_TYPE_SERVICE_CONTENT =
      "I use ACI to find and refer skilled resources.";

//--------------------------------------------------- Resource List -----------------------------------------------------------------------------------------

  static const String RESOURCE_LIST_PAGE_TITLE = "My Resources";

  static const String RESOURCE_LIST_HEADER_TITLE = "Your Search Results";

  static const String RESOURCE_LIST_NEIGHBOUR_HEADER_TITLE = " In your neighborhood "; 

static const String RESOURCE_LIST_RESOURCE_TYPE_EXTERNAL = "external"; 
static const String RESOURCE_LIST_RESOURCE_TYPE_INTERNAL = "internal"; 
static const String isRedirectFromResourceSearchList = "resource_search_list"; 
static const String isRedirectFromHomeOrFav = "homPageorFav"; 

  //--------------------------------------------------- Choose Profile -----------------------------------------------------------------------------------------

  static const String WELCOME_SCREEN_TITLE = "Welcome!";

  static const String WELCOME_SCREEN_SUB_TITLE = "Protect your loved ones. Find vacant beds, oxygen supplies, vaccination centers, ambulances and other important contact informations. Let us know what you need, and where, we will reach you when they are available near you. Let’s fight germs  together!";

  static const String WELCOME_SCREEN_NAME_LIST = "";

  static const String WELCOME_SCREEN_NAME_CONTENT = "  Start searching for reliable resources referred by your friends.";

  static const String WELCOME_SCREEN_ADD_RESOURCE = "Add resources for your friends to benefit. Invite your contacts to share the resources they used.";

  static const String WELCOME_SCREEN_BT_GOTORES_LBL = "Go to Resources";



  //--------------------------------------------------- Contact Access -----------------------------------------------------------------------------------------

  static const String CONTACT_ACCESS_SCREEN_TITLE = "Who my contacts recommend?";

//  static const String CONTACT_ACCESS_SCREEN_SUB_TITLE = "ACI will now find what your friends recommend for you.The larger your connections the more trusted recommendations you will see.";
//
//  static const String CONTACT_ACCESS_SCREEN_NAME_LIST = "ACI will do this by accessing only the phone numbers in your contacts.";
//
//  static const String CONTACT_ACCESS_SCREEN__CONTENT = " Once you started recommending services and resources that you came across they will be shared among your connections.You can remove your recommendations at any time.";


  static const String CONTACT_ACCESS_SCREEN_SUB_TITLE = "The Cancer Institute (WIA) is a public charitable voluntary institute dedicated to the care of cancer for the last 60 years. The ethos of the Cancer Institute (WIA) is service to all irrespective of social or economical class";

  static const String CONTACT_ACCESS_SCREEN_NAME_LIST = "You can start recommending people and services after this step. Remember, your recommendations are valued high by your connections. You can remove your recommendations at any time.";

  static const String CONTACT_ACCESS_SCREEN__CONTENT = "The larger your connections the more trusted recommendations you will see.";


  static const String CONTACT_ACCESS_SCREEN_BT_NEXT_LBL = "Next";


  //--------------------------------------------------- QR Dialog Data -----------------------------------------------------------------------------------------

  static const String QR_DIALOG_DATA_TITLE = "My info";

  static const String QR_DIALOG_DATA_RESOURCE_TITLE = "Resource info";

  static const String QR_DIALOG_DATA_SUB_TITLE = "Show it in person or capture to send it";

  static const String QR_DIALOG_DATA_CLOSE = "Close";

  static const String QR_DIALOG_DIG_INVALID_QR_TITLE = "Invalid QR";

  static const String QR_DIALOG_DIG_INVALID_QR_CONTENT = "Not a valid ACI QR";

  //---------------------------------------------------My Resource -----------------------------------------------------------------------------------------

  static const String MY_RESOURCE_TITLE = "My Resources";


  //--------------------------------------------------- Resource Favorite -----------------------------------------------------------------------------------------

  static const String RESOURCE_FAVORITE_TITLE = "Your Favorites";

  static const String RESOURCE_FAVORITE_SUB_TITLE = "Your go-to crew!";

  static const String SURVEY_SUB_TITLE = "Survey";

  static const String RESOURCE_FAVORITE_LIST_TITLE = "Favorites";

  //--------------------------------------------------- APP FeedBack -----------------------------------------------------------------------------------------

  static const String APP_FEEDBACK_TITLE = "App Feedback";


  static const String APP_FEEDBACK_ISSUE_HINT = "Select Issue";
  static const String APP_FEEDBACK_ISSUE_LABEL = "Issue Type";

  static const String APP_FEEDBACK_DETAILS_HINT = "Please describe the issue.";
  static const String APP_FEEDBACK_DETAILS_LABEL = "Details  ";

  //static const String APP_FEEDBACK_SUBMIT_LABEL = "Submit";
  static const String APP_FEEDBACK_SUBMIT_LABEL = "Submitted";
  static const String APP_FEEDBACK_CLEAR_LABEL = "Clear";


  static const String APP_FEEDBACK_DIAG_SUCCESS_TITLE = "Submitted";
  static const String APP_FEEDBACK_DIAG_SUCCESS_CONTENT = "Your Issue Track ID is ";
  static const String APP_FEEDBACK_DIAG_SUCCESS_BT_LBL = "Ok";
  static const String APP_FEEDBACK_DIAG_FAILURE_TITLE = "Failure";

  //--------------------------------------------------- Help -----------------------------------------------------------------------------------------

  static const String APP_HELP_TITLE = "Help";

  static const String APP_HELP_SUB_TITLE_ONE = "What does ACI Mobile App do?";
  static const String APP_HELP_SUB_CONTENT_ONE = "Adyar Cancer Institute (ACI) mobile application enables care providers to share valuable treatment informations including videos, documents and other instructions on time. Your care providers will be able to collect important health activities, food intakes and other side effect through simple surveys to help assess your health condition and adjust treatments.";

  static const String APP_HELP_SUB_TITLE_TWO = "How do my Care Team share information's?";
  static const String APP_HELP_SUB_CONTENT_TWO = "Your Care Team of Doctors will periodically share instructional videos and other documents directly through this mobile application. You will be notified as soon as an instructional material is shared with you.";

  static const String APP_HELP_SUB_TITLE_THREE = "How do I send my health conditions and treatment follow ups to my Doctors?";
  static const String APP_HELP_SUB_CONTENT_THREE = "Your Doctor will send a set of simple questions through the mobile application. By simply answering those questions your Doctor will know your activities such as daily physical exercises and food intakes.";

  static const String APP_HELP_SUB_TITLE_FOUR = "What if I forgot to send the feedback?";
  static const String APP_HELP_SUB_CONTENT_FOUR = "The system will send reminders to fill and submit the treatment followup questions.";

  static const String APP_HELP_SUB_TITLE_FIVE = "";
  static const String APP_HELP_SUB_CONTENT_FIVE = "";
  static const String TITLE = "Title";
  static const String DESC = "Description";
  static const String CHANNEL = "Channel";



}
