class Query {
  static final String createTableToken = "create table Token(name varchar(255) primary key,token varchar(255) null)";
  static final String createTableSetting = "create table AppSetting (name varchar(255) primary key,val varchar(255))";
  static final String createTableUser = "CREATE TABLE InformationUser (id INTEGER PRIMARY KEY,user_name varchar(255),created_at INTEGER,phone varchar(255),urlAvatar varchar(255),email varchar(255),updatedAt INTEGER,role varchar(255),completedLessons varchar(255),progress varchar(255),streak varchar(255),language varchar(255),heart varchar(255),gem varchar(255),xp INTEGER,lastCompletionDate varchar(255),last_lesson TEXT,total_lessons INTEGER,total_score REAL)";
}