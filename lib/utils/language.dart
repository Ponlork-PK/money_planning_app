import 'package:get/get.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en": {

      // --- Login ---
      "welcomeTitle": "Welcome to\nMoney Planning App",
      "emailLabel": "Email",
      "passwordLabel": "Password",
      "emailRequired": "Email is required",
      "passwordRequired": "Password is required",
      "getStart": "Get Start",
      "loginFailed": "Login failed",

      // --- Dashboard ---
      "dashboard": "Dashboard",
      "balance": "Balance",
      "income": "Income",
      "expense": "Expense",
      "addTransaction": "Add transaction",
      "recentActivity": "Recent Activities",
      "noTransaction": "No transaction yet",

      // --- Transaction ---
      "transaction": "Transaction",
      "tsHistory": "Transaction Histories",
      "searchTs": "Search your transactions",
      "typeToSearch": "Type to search transactions...",
      "noResult": "No result",

      // --- Add / Edit Transaction ---
      "addTransactionTitle": "Add Transaction",
      "updateTransaction": "Update Transaction",
      "amountLabel": "Amount",
      "transactionType": "Transaction Type",
      "incomeLabel": "Income",
      "expenseLabel": "Expense",
      "inputDate": "Input Date",
      "selectDate": "Select Date",
      "purposeLabel": "Purpose",
      "itemNameLabel": "Item Name",
      "itemNameHint": "Item name",
      "paymentMethodLabel": "Payment Method",
      "paymentMethodHint": "Cash / Card / Bank / ...",
      "saveBtn": "Save",
      "updateBtn": "Update",

      // --- Transaction Detail ---
      "txType": "Type",
      "txDate": "Date",
      "txPaymentMethod": "Payment Method",
      "txCurrency": "Currency",
      "txNote": "Note",

      // --- Report ---
      "report": "Report",
      "daily": "Daily",
      "weekly": "Weekly",
      "monthly": "Monthly",
      "in_and_exp": "Income vs. Expense",
      "topTs": "Top Transactions",

      // --- Loan ---
      "loan": "Loan",
      "all": "All",
      "bank": "Bank",
      "micro": "Micro",
      "personal": "Personal",
      "noLoans": "No loans yet.",
      "retry": "Retry",
      "loanDetailTitle": "Loan Details",
      "paymentSchedule": "Payment Schedule",
      "noPaymentSchedule": "No payment schedule yet.",
      "currentLoan": "Current loan",
      "loanSummary": "Loan Summary",
      "lenderLabel": "Lender",
      "originalAmount": "Original Amount",
      "interestRate": "Interest Rate",
      "loanTerm": "Loan Term",
      "months": "months",
      "startLabel": "Start",
      "endLabel": "End",
      "nextRepayment": "Next repayment",
      "purposeOfLoan": "Purpose",
      "settleLoan": "Settle Loan Early",
      "editLoan": "Edit Loan",

      // --- Add Loan ---
      "addLoanTitle": "Add New Loan",
      "editLoanTitle": "Edit Loan",
      "loanTermsLabel": "Loan Terms",
      "loanerName": "Loaner Name",
      "lenderNameHint": "Lender Name",
      "amountsHint": "Amounts",
      "interestRateHint": "Interest rate (%)",
      "loanTermHint": "Loan term (months)",
      "currencyLabel": "Currency",
      "startDateLabel": "Start",
      "endDateLabel": "End",
      "selectDateHint": "Select",
      "purposeOfLoanLabel": "Purpose of Loan",
      "enterPurposeHint": "Enter purpose of loan",
      "saveLoanBtn": "Save",

      // --- Bottom Nav ---
      "navHome": "Home",
      "navTransaction": "Transaction",
      "navReport": "Report",
      "navLoan": "Loan",
      "navSettings": "Settings",

      // --- Setting ---
      "setting": "Settings",
      "defaultCurrency": "Default Currency",
      "preference": "Preferences",
      "darkMode": "Dark Mode",
      "language": "Language",
      "notification": "Notification",
      "usd": "USD",
      "khr": "KHR",

      // --- Logout ---
      "logout": "Log Out",
      "logoutConfirm": "Are you sure you want to log out?",
      "loggedOut": "Logged Out",
      "loggedOutMessage": "You have been signed out successfully.",
      "loggingOut": "Logging out...",
      "cancel": "Cancel",

    },
    "km": {
      // --- Login ---
      "welcomeTitle": "សូមស្វាគមន៍មកកាន់\nកម្មវិធីគ្រប់គ្រងលុយ",
      "emailLabel": "អ៊ីមែល",
      "passwordLabel": "លេខសម្ងាត់",
      "emailRequired": "សូមបញ្ចូលអ៊ីមែល",
      "passwordRequired": "សូមបញ្ចូលលេខសម្ងាត់",
      "getStart": "ចូល",
      "loginFailed": "ការចូលបរាជ័យ",

      // --- Dashboard ---
      "dashboard": "ផ្ទាំងគ្រប់គ្រង",
      "balance": "តុល្យភាព",
      "income": "ចំណូល",
      "expense": "ចំណាយ",
      "addTransaction": "បន្ថែមប្រតិបត្តិការ",
      "recentActivity": "សកម្មភាពថ្មីៗ",
      "noTransaction": "មិនទាន់មានប្រតិបត្តិការ",

      // --- Transaction ---
      "transaction": "ប្រតិបត្តិការ",
      "tsHistory": "ប្រវត្តិប្រតិបត្តិការ",
      "searchTs": "ស្វែងរកប្រតិបត្តិការ",
      "typeToSearch": "សរសេរដើម្បីស្វែងរក...",
      "noResult": "មិនមានលទ្ធផល",

      // --- Add / Edit Transaction ---
      "addTransactionTitle": "បន្ថែមប្រតិបត្តិការ",
      "updateTransaction": "កែប្រែប្រតិបត្តិការ",
      "amountLabel": "ចំនួនទឹកប្រាក់",
      "transactionType": "ប្រភេទប្រតិបត្តិការ",
      "incomeLabel": "ចំណូល",
      "expenseLabel": "ចំណាយ",
      "inputDate": "ថ្ងៃខែឆ្នាំ",
      "selectDate": "ជ្រើសរើសថ្ងៃ",
      "purposeLabel": "គោលបំណង",
      "itemNameLabel": "ឈ្មោះទំនិញ",
      "itemNameHint": "ឈ្មោះទំនិញ",
      "paymentMethodLabel": "វិធីបង់ប្រាក់",
      "paymentMethodHint": "សាច់ប្រាក់ / កាត / ធនាគារ / ...",
      "saveBtn": "រក្សាទុក",
      "updateBtn": "កែប្រែ",

      // --- Transaction Detail ---
      "txType": "ប្រភេទ",
      "txDate": "ថ្ងៃខែ",
      "txPaymentMethod": "វិធីបង់ប្រាក់",
      "txCurrency": "រូបិយប័ណ្ណ",
      "txNote": "កំណត់ចំណាំ",

      // --- Report ---
      "report": "របាយការណ៍",
      "daily": "ប្រចាំថ្ងៃ",
      "weekly": "ប្រចាំសប្ដាហ៍",
      "monthly": "ប្រចាំខែ",
      "in_and_exp": "ចំណូល និង ចំណាយ",
      "topTs": "ប្រតិបត្តិការខ្ពស់ៗ",

      // --- Loan ---
      "loan": "កម្ចី",
      "all": "ទាំងអស់",
      "bank": "ធនាគារ",
      "micro": "ស្ថាប័ណ្ឌ",
      "personal": "ផ្តាល់ខ្លួន",
      "noLoans": "មិនទាន់មានកម្ចី",
      "retry": "សាកល្បងម្ដងទៀត",
      "loanDetailTitle": "ព័ត៌មានលំអិតកម្ចី",
      "paymentSchedule": "កាលវិភាគការទូទាត់",
      "noPaymentSchedule": "មិនទាន់មានកាលវិភាគ",
      "currentLoan": "កម្ចីបច្ចុប្បន្ន",
      "loanSummary": "សង្ខេបកម្ចី",
      "lenderLabel": "អ្នកផ្ដល់កម្ចី",
      "originalAmount": "ចំនួនដើម",
      "interestRate": "អត្រាការប្រាក់",
      "loanTerm": "រយៈពេល",
      "months": "ខែ",
      "startLabel": "ចាប់ផ្ដើម",
      "endLabel": "បញ្ចប់",
      "nextRepayment": "ការទូទាត់បន្ទាប់",
      "purposeOfLoan": "គោលបំណងកម្ចី",
      "settleLoan": "សងកម្ចីមុនកំណត់",
      "editLoan": "កែប្រែកម្ចី",

      // --- Add Loan ---
      "addLoanTitle": "បន្ថែមកម្ចីថ្មី",
      "editLoanTitle": "កែប្រែកម្ចី",
      "loanTermsLabel": "លក្ខខណ្ឌកម្ចី",
      "loanerName": "ឈ្មោះអ្នកផ្ដល់កម្ចី",
      "lenderNameHint": "ឈ្មោះអ្នកផ្ដល់កម្ចី",
      "amountsHint": "ចំនួនទឹកប្រាក់",
      "interestRateHint": "អត្រាការប្រាក់ (%)",
      "loanTermHint": "រយៈពេលកម្ចី (ខែ)",
      "currencyLabel": "រូបិយប័ណ្ណ",
      "startDateLabel": "ថ្ងៃចាប់ផ្ដើម",
      "endDateLabel": "ថ្ងៃបញ្ចប់",
      "selectDateHint": "ជ្រើសរើស",
      "purposeOfLoanLabel": "គោលបំណងនៃការខ្ចី",
      "enterPurposeHint": "បញ្ចូលគោលបំណង",
      "saveLoanBtn": "រក្សាទុក",

      // --- Bottom Nav ---
      "navHome": "ទំព័រដើម",
      "navTransaction": "ប្រតិបត្តិការ",
      "navReport": "របាយការណ៍",
      "navLoan": "កម្ចី",
      "navSettings": "ការកំណត់",

      // --- Setting ---
      "setting": "ការកំណត់",
      "defaultCurrency": "រូបិយប័ណ្ណគោល",
      "preference": "ចំណូលចិត្ត",
      "darkMode": "ភាពងងឹត",
      "language": "ភាសា",
      "notification": "សារដំណឹង",
      "usd": "ដុល្លារ",
      "khr": "រៀល",

      // --- Logout ---
      "logout": "ចាកចេញ",
      "logoutConfirm": "តើអ្នកចង់ចាកចេញមែនទេ?",
      "loggedOut": "បានចាកចេញ",
      "loggedOutMessage": "អ្នកបានចាកចេញដោយជោគជ័យ។",
      "loggingOut": "កំពុងចាកចេញ...",
      "cancel": "បោះបង់",
    }
  };
}