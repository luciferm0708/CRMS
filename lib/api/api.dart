class API{
  static const hostConnection = "http://192.168.68.105/api_crms";
  static const hostConnectionPeople = "$hostConnection/people";

  static const peopleRegister = "$hostConnection/people/peopleReg.php";
  static const validateEmail = "$hostConnection/people/validate_email.php";
  static const logIn = "$hostConnection/people/login.php";
  static const peoproImg = "$hostConnection/people/peoproimg.php";
  static const report = "$hostConnection/crimeReports/reports.php";
  static const fetchReports = "$hostConnection/fetch/fetchReports.php";
  static const professionalReg = "$hostConnection/professionals/professionalReg.php";
  static const prof_login = "$hostConnection/professionals//prof_login.php";//prof_login
  static const validate_email_prof = "$hostConnection/professionals/validate_email_prof.php";
  static const get_current_job = "$hostConnection/professionals/getcurrentjob.php";
  static const assign_crime = "$hostConnection/professionals/assignCrime.php";
  static const updateAssignedJobs = "$hostConnection/professionals/updatejobsassigned.php";
  static const fetchAssignedJobs = "$hostConnection/professionals/fetchassigned.php";
  static const reactToPost = "$hostConnection/reactions/reactions.php";
  static const addComment = "$hostConnection/comment/comments.php";
}