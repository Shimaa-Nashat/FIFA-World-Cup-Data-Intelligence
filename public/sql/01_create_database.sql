-- =========================================================
-- Create the database
-- =========================================================

CREATE DATABASE FIFA_World_Cup_Analytics;
USE FIFA_World_Cup_Analytics;

-- =========================================================
-- Confederations Table
-- =========================================================

CREATE TABLE Confederations(
	ConfederationID VARCHAR(10) PRIMARY KEY,
	ConfederationName NVARCHAR(150) NOT NULL UNIQUE,
	ConfederationCode NVARCHAR(20) NOT NULL UNIQUE,
	WikipediaLink NVARCHAR(100) NOT NULL
);

-- =========================================================
-- Federations Table
-- =========================================================

CREATE TABLE Federations(
	FederationID VARCHAR(10) PRIMARY KEY,
	FederationName NVARCHAR(100) NOT NULL UNIQUE,
	RegionName NVARCHAR(30) NOT NULL,
	WikipediaLink NVARCHAR(150) NOT NULL
);

-- =========================================================
-- Teams Table
-- =========================================================

CREATE TABLE Teams(
	TeamID VARCHAR(10) PRIMARY KEY,
	TeamName NVARCHAR(50) NOT NULL UNIQUE,
	TeamCode NVARCHAR(10) NOT NULL,
	MensTeam BIT NOT NULL,
	WomensTeam BIT NOT NULL,
	FederationID VARCHAR(10) FOREIGN KEY REFERENCES Federations (FederationID),
	ConfederationID VARCHAR(10) FOREIGN KEY REFERENCES Confederations (ConfederationID)
);

-- =========================================================
-- Players Table
-- =========================================================

CREATE TABLE Players(
	PlayerID VARCHAR(50) PRIMARY KEY,
	FamilyName NVARCHAR(50),
	GivenName NVARCHAR(30),
	BirthDate DATE,
	Female BIT,
	GoalKeeper BIT,
	Defender BIT,
	Midfielder BIT,
	Forward BIT,
	CountTournaments INT,
	ListTournaments NVARCHAR(100),
	WikipediaLink NVARCHAR(150),
	DisplayName NVARCHAR(50) NOT NULL
);

-- =========================================================
-- Tournaments Table
-- =========================================================

CREATE TABLE Tournaments(
	TournamentID VARCHAR(20) PRIMARY KEY,
	TournamentName NVARCHAR(50) NOT NULL,
	TournamentYear INT NOT NULL,
	Gender NVARCHAR(10) NOT NULL CHECK(Gender IN ('Men','Women')),
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	HostCountry NVARCHAR(50) NOT NULL,
	WinnerTeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	HostWon BIT NOT NULL,
	CountTeams INT NOT NULL,
	GroupStage BIT NOT NULL,
	SecondGroupStage BIT NOT NULL,
	FinalRound BIT NOT NULL,
	RoundOf16 BIT NOT NULL,
	QuarterFinals BIT NOT NULL,
	SemiFinals BIT NOT NULL,
	ThirdPlaceMatch BIT NOT NULL,
	Final BIT NOT NULL,
	CONSTRAINT CK_Tournaments_Dates CHECK(EndDate>=StartDate)
);

-- =========================================================
-- Stadiums Table
-- =========================================================

CREATE TABLE Stadiums(
	StadiumID VARCHAR(10) PRIMARY KEY,
	StadiumName NVARCHAR(50) NOT NULL,
	CityName NVARCHAR(30),
	CountryName NVARCHAR(20),
	StadiumCapacity INT CHECK(StadiumCapacity>0)
);

-- =========================================================
-- Matches Table
-- =========================================================

CREATE TABLE Matches(
	MatchID VARCHAR(30) PRIMARY KEY,
	TournamentID VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES Tournaments (TournamentID),
	StageName NVARCHAR(30) NOT NULL,
	GroupName NVARCHAR(20),
	MatchDate DATE NOT NULL,
	MatchTime TIME(0) NOT NULL,
	StadiumID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Stadiums (StadiumID),
	HomeTeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	AwayTeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	HomeScore INT NOT NULL CHECK(HomeScore>=0),
	AwayScore INT NOT NULL CHECK(AwayScore>=0),
	HomeScoreMargin INT NOT NULL,
	AwayScoreMargin INT NOT NULL,
	ExtraTime BIT NOT NULL,
	PenaltyShootout BIT NOT NULL,
	ScorePenalties NVARCHAR(10) NOT NULL,
	HomePenaltyScore INT NOT NULL,
	AwayPenaltyScore INT NOT NULL,
	Result NVARCHAR(20) NOT NULL,
	HomeTeamWin BIT NOT NULL,
	AwayTeamWin BIT NOT NULL,
	Draw BIT NOT NULL,
	CONSTRAINT CK_Matches_DifferentTeams CHECK(HomeTeamID<>AwayTeamID)
);

-- =========================================================
-- Team_Appearances Table
-- =========================================================

CREATE TABLE Team_Appearances(
	TeamAppearanceID VARCHAR(50) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	OpponentID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	HomeAway NVARCHAR(10) NOT NULL CHECK(HomeAway IN ('home','away')),
	GoalsFor INT NOT NULL,
	GoalsAgainst INT NOT NULL,
	GoalDifferential INT NOT NULL,
	ExtraTime BIT NOT NULL,
	PenaltyShootout BIT NOT NULL,
	PenaltiesFor INT NOT NULL,
	PenaltiesAgainst INT NOT NULL,
	Result NVARCHAR(10) NOT NULL CHECK(Result IN ('win','lose','draw')),
	Win BIT NOT NULL,
	Lose BIT NOT NULL,
	Draw BIT NOT NULL,
	Source2MatchTeamID NVARCHAR(50),
	CONSTRAINT UQ_Match_Team UNIQUE(MatchID, TeamID)
);

-- =========================================================
-- Player_Appearances Table
-- =========================================================

CREATE TABLE Player_Appearances(
	AppearanceID VARCHAR(50) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	PlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	TeamAppearanceID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Team_Appearances (TeamAppearanceID),
	ShirtNumber INT NOT NULL,
	PositionName NVARCHAR(30) NOT NULL,
	PositionCode NVARCHAR(10) NOT NULL,
	Starter BIT NOT NULL,
	Substitute BIT NOT NULL,
	Appeared BIT NOT NULL,
	Status NVARCHAR(20),
	TeamRole NVARCHAR(10) NOT NULL,
	GoalMinutes NVARCHAR(20),
	OwnGoalMinutes INT,
	YellowCardMinutes NVARCHAR(10),
	RedCardMinutes INT,
	SubbedOnMinutes INT,
	SubbedOffMinutes INT,
	Source2AppearanceID NVARCHAR(50),
	CONSTRAINT UQ_Match_Player UNIQUE(MatchID, PlayerID)
);

-- =========================================================
-- Goals Table
-- =========================================================

CREATE TABLE Goals(
	GoalID VARCHAR(20) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	PlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	PlayerTeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	MinuteRegulation INT NOT NULL CHECK(MinuteRegulation>=0),
	MinuteStoppage INT NOT NULL,
	MatchPeriod NVARCHAR(100) NOT NULL,
	OwnGoal BIT NOT NULL,
	Penalty BIT NOT NULL,
	Source2EventID NVARCHAR(50)
);

-- =========================================================
-- Bookings Table
-- =========================================================

CREATE TABLE Bookings(
	BookingID VARCHAR(20) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	PlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	MinuteRegulation INT NOT NULL CHECK(MinuteRegulation>=0),
	MinuteStoppage INT NOT NULL,
	MatchPeriod NVARCHAR(100) NOT NULL,
	YellowCard BIT NOT NULL,
	RedCard BIT NOT NULL,
	SecondYellowCard BIT NOT NULL,
	SendingOff BIT NOT NULL,
	Source2EventID NVARCHAR(50)
);

-- =========================================================
-- Substitutions Table
-- =========================================================

CREATE TABLE Substitutions(
	SubstitutionID VARCHAR(20) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	PlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	MinuteRegulation INT NOT NULL CHECK(MinuteRegulation>=0),
	MinuteStoppage INT NOT NULL,
	MatchPeriod NVARCHAR(100) NOT NULL,
	GoingOff BIT NOT NULL,
	ComingOn BIT NOT NULL,
	Source2EventID NVARCHAR(50),
	CONSTRAINT CK_Substitutions_OnOff CHECK(GoingOff<>ComingOn)
);

-- =========================================================
-- Match_Attendance Table
-- =========================================================

CREATE TABLE Match_Attendance(
	AttendanceID VARCHAR(10) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	Attendance INT NOT NULL CHECK(Attendance>0),
	Source NVARCHAR(100) NOT NULL,
	SourceNote NVARCHAR(100),
	CONSTRAINT UQ_Match_Attendance UNIQUE(MatchID)
);

-- =========================================================
-- Player_Match_Stats Table
-- =========================================================

CREATE TABLE Player_Match_Stats(
	AppearanceID VARCHAR(50) PRIMARY KEY FOREIGN KEY REFERENCES Player_Appearances (AppearanceID),
	CrossesAttempted INT NOT NULL,
	CrossesCompleted INT NOT NULL,
	Cutbacks INT NOT NULL,
	DrivenCrosses INT NOT NULL,
	InswingCrosses INT NOT NULL,
	LoftedCrosses INT NOT NULL,
	OutswingCrosses INT NOT NULL,
	PushCrosses INT NOT NULL,
	AttemptsAtGoal INT NOT NULL,
	Goals INT NOT NULL,
	BallProgressions INT NOT NULL,
	PassesAttempted INT NOT NULL,
	PassesCompleted INT NOT NULL,
	PassCompletionPct NVARCHAR(10) NOT NULL,
	LineBreaksAttempted INT NOT NULL,
	LineBreaksCompleted INT NOT NULL,
	LineBreakCompletionPct NVARCHAR(10) NOT NULL,
	TakeOns INT NOT NULL,
	SwitchesOfPlay INT NOT NULL,
	StepIns INT NOT NULL,
	LineBreakDirectionAround INT NOT NULL,
	LineBreakDirectionOver INT NOT NULL,
	LineBreakDirectionThrough INT NOT NULL,
	LineBreakDistributionBallProgression INT NOT NULL,
	LineBreakDistributionCross INT NOT NULL,
	LineBreakDistributionPass INT NOT NULL,
	LineBreakFourUnitsAttackingLine INT NOT NULL,
	LineBreakFourUnitsAttackingMidfieldLine INT NOT NULL,
	LineBreakFourUnitsDefensiveLine INT NOT NULL,
	LineBreakFourUnitsMidfieldLine INT NOT NULL,
	LineBreakThreeUnitsAttackingLine INT NOT NULL,
	LineBreakThreeUnitsDefensiveLine INT NOT NULL,
	LineBreakThreeUnitsMidfieldLine INT NOT NULL,
	LineBreakTwoUnitsDefensiveLine INT NOT NULL,
	LineBreakTwoUnitsMidfieldLine INT NOT NULL,
	OffersInBehind INT NOT NULL,
	OffersInBetween INT NOT NULL,
	OffersInFront INT NOT NULL,
	OffersInToOut INT NOT NULL,
	OffersNoMovement INT NOT NULL,
	OffersReceived INT NOT NULL,
	OffersOutToIn INT NOT NULL,
	TotalOffers INT NOT NULL,
	Blocks INT NOT NULL,
	Clearances INT NOT NULL,
	DuelsWonAerial INT NOT NULL,
	DuelsWonPhysical INT NOT NULL,
	Interceptions INT NOT NULL,
	LooseBallReceptions INT NOT NULL,
	PossessionContestsWon INT NOT NULL,
	PossessionInterrupted INT NOT NULL,
	PossessionRegains INT NOT NULL,
	PressingDirect INT NOT NULL,
	PressingIndirect INT NOT NULL,
	PushingOn INT NOT NULL,
	PushingOnIntoPressing INT NOT NULL,
	TacklesMadeWon NVARCHAR(10) NOT NULL,
	HighSpeedRunsZone3 INT NOT NULL,
	SprintsZone4_5 INT NOT NULL,
	TopSpeedKmh DECIMAL(18,1) NOT NULL,
	TotalDistanceM DECIMAL(18,1) NOT NULL,
	Zone1_0_7KmhM DECIMAL(18,1) NOT NULL,
	Zone2_7_15KmhM DECIMAL(18,1) NOT NULL,
	Zone3_15_20KmhM DECIMAL(18,1) NOT NULL,
	Zone4_20_25KmhM DECIMAL(18,1) NOT NULL,
	Zone5_25PlusKmhM DECIMAL(18,1) NOT NULL
);

-- =========================================================
-- Team_Match_Stats Table
-- =========================================================

CREATE TABLE Team_Match_Stats(
	TeamMatchStatID VARCHAR(20) PRIMARY KEY,
	TeamAppearanceID VARCHAR(50) FOREIGN KEY REFERENCES Team_Appearances (TeamAppearanceID),
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamID VARCHAR(10) FOREIGN KEY REFERENCES Teams (TeamID),
	StatGroup NVARCHAR(50) NOT NULL,
	Metric NVARCHAR(100) NOT NULL,
	ValueNumeric DECIMAL(18,2),
	Unit NVARCHAR(10),
	RawValue NVARCHAR(20) NOT NULL,
	Category NVARCHAR(50),
	Phase NVARCHAR(30),
	FromLeftSide INT,
	FromRightSide INT,
	SourceFile NVARCHAR(50) NOT NULL
);

-- =========================================================
-- Passing_Network_Edges Table
-- =========================================================

CREATE TABLE Passing_Network_Edges(
	EdgeID VARCHAR(50) PRIMARY KEY,
	MatchID VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Matches (MatchID),
	TeamAppearanceID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Team_Appearances (TeamAppearanceID),
	TeamID VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES Teams (TeamID),
	FromAppearanceID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Player_Appearances (AppearanceID),
	ToAppearanceID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Player_Appearances (AppearanceID),
	FromPlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	ToPlayerID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Players (PlayerID),
	PassCount INT NOT NULL
);

-- =========================================================
-- FIFA_Rankings Table
-- =========================================================

CREATE TABLE FIFA_Rankings(
	RankingID VARCHAR(10) PRIMARY KEY,
	RankingDate DATE NOT NULL,
	RankingTeamName NVARCHAR(50) NOT NULL,
	WorldCupTeamID VARCHAR(10) FOREIGN KEY REFERENCES Teams (TeamID),
	RankPosition INT NOT NULL CHECK(RankPosition>=1),
	Points DECIMAL(18,2) NOT NULL
);

-- =========================================================
-- Find the number of columns in every table.
-- =========================================================
SELECT TABLE_NAME AS TableName,
    COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS
GROUP BY TABLE_NAME
ORDER BY TotalColumns DESC;