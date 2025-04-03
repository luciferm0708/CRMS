import 'package:flutter/foundation.dart';

class API{
  static const hostConnection = kIsWeb ? "http://192.168.68.108/api_crms" : "http://10.0.2.2/api_crms";
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
  static const fetchReacts = "$hostConnection/reactions/fetchreactions.php";
  static const addComment = "$hostConnection/comment/comments.php";
  static const reactToPostProf = "$hostConnection/prof_reaction/prof_reactions.php";
  static const fetchReactsProf = "$hostConnection/prof_reaction/fetch_profReactions.php";
  static const addProfComment = "$hostConnection/prof_comment/prof_comments.php";
  static const fetchProfComment = "$hostConnection/prof_comment/fetch_profComments.php";
  static const uploadProfProfileImage = "$hostConnection/professionals/professional_image.php";
}