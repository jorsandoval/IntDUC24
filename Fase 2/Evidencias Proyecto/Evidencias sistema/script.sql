create table AspNetRoles
(
    Id               int auto_increment
        primary key,
    Name             varchar(256) null,
    NormalizedName   varchar(256) null,
    ConcurrencyStamp longtext     null,
    constraint RoleNameIndex
        unique (NormalizedName)
);

create table AspNetRoleClaims
(
    Id         int auto_increment
        primary key,
    RoleId     int      not null,
    ClaimType  longtext null,
    ClaimValue longtext null,
    constraint FK_AspNetRoleClaims_AspNetRoles_RoleId
        foreign key (RoleId) references AspNetRoles (Id)
            on delete cascade
);

create index IX_AspNetRoleClaims_RoleId
    on AspNetRoleClaims (RoleId);

create table AspNetUsers
(
    Id                   int auto_increment
        primary key,
    FirstName            longtext     not null,
    LastName             longtext     not null,
    Rut                  longtext     not null,
    BirthDate            datetime(6)  not null,
    Admission            datetime(6)  not null,
    RefreshToken         longtext     not null,
    RefreshTokenExpiry   datetime(6)  null,
    UserName             varchar(256) null,
    NormalizedUserName   varchar(256) null,
    Email                varchar(256) null,
    NormalizedEmail      varchar(256) null,
    EmailConfirmed       tinyint(1)   not null,
    PasswordHash         longtext     null,
    SecurityStamp        longtext     null,
    ConcurrencyStamp     longtext     null,
    PhoneNumber          longtext     null,
    PhoneNumberConfirmed tinyint(1)   not null,
    TwoFactorEnabled     tinyint(1)   not null,
    LockoutEnd           datetime     null,
    LockoutEnabled       tinyint(1)   not null,
    AccessFailedCount    int          not null,
    constraint UserNameIndex
        unique (NormalizedUserName)
);

create table AspNetUserClaims
(
    Id         int auto_increment
        primary key,
    UserId     int      not null,
    ClaimType  longtext null,
    ClaimValue longtext null,
    constraint FK_AspNetUserClaims_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade
);

create index IX_AspNetUserClaims_UserId
    on AspNetUserClaims (UserId);

create table AspNetUserLogins
(
    LoginProvider       varchar(255) not null,
    ProviderKey         varchar(255) not null,
    ProviderDisplayName longtext     null,
    UserId              int          not null,
    primary key (LoginProvider, ProviderKey),
    constraint FK_AspNetUserLogins_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade
);

create index IX_AspNetUserLogins_UserId
    on AspNetUserLogins (UserId);

create table AspNetUserRoles
(
    UserId int not null,
    RoleId int not null,
    primary key (UserId, RoleId),
    constraint FK_AspNetUserRoles_AspNetRoles_RoleId
        foreign key (RoleId) references AspNetRoles (Id)
            on delete cascade,
    constraint FK_AspNetUserRoles_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade
);

create index IX_AspNetUserRoles_RoleId
    on AspNetUserRoles (RoleId);

create table AspNetUserTokens
(
    UserId        int          not null,
    LoginProvider varchar(255) not null,
    Name          varchar(255) not null,
    Value         longtext     null,
    primary key (UserId, LoginProvider, Name),
    constraint FK_AspNetUserTokens_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade
);

create index EmailIndex
    on AspNetUsers (NormalizedEmail);

create table Attendances
(
    ID        int auto_increment
        primary key,
    ClockIn   datetime(6) not null,
    ClockOut  datetime(6) not null,
    Date      datetime(6) not null,
    UserId    int         not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null,
    constraint FK_Attendances_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade
);

create index IX_Attendances_UserId
    on Attendances (UserId);

create table ChargeTypes
(
    ID          int auto_increment
        primary key,
    Description longtext    not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null
);

create table ExpenseTypes
(
    ID          int auto_increment
        primary key,
    Description longtext    not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null
);

create table Regions
(
    ID        int auto_increment
        primary key,
    Name      longtext    not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null
);

create table City
(
    ID        int auto_increment
        primary key,
    Name      longtext    not null,
    RegionID  int         not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null,
    constraint FK_City_Regions_RegionID
        foreign key (RegionID) references Regions (ID)
            on delete cascade
);

create index IX_City_RegionID
    on City (RegionID);

create table Municipality
(
    ID        int auto_increment
        primary key,
    Name      longtext    not null,
    CityID    int         not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null,
    constraint FK_Municipality_City_CityID
        foreign key (CityID) references City (ID)
            on delete cascade
);

create table Community
(
    ID             int auto_increment
        primary key,
    Name           longtext    not null,
    Rut            longtext    not null,
    Address        longtext    not null,
    FoundationDate datetime(6) not null,
    MunicipalityID int         not null,
    CreatedAt      datetime(6) not null,
    UpdatedAt      datetime(6) not null,
    IsDeleted      tinyint(1)  not null,
    constraint FK_Community_Municipality_MunicipalityID
        foreign key (MunicipalityID) references Municipality (ID)
            on delete cascade
);

create table Buildings
(
    ID          int auto_increment
        primary key,
    Name        longtext    not null,
    CommunityID int         not null,
    Floors      int         not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Buildings_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade
);

create index IX_Buildings_CommunityID
    on Buildings (CommunityID);

create table Charges
(
    ID          int auto_increment
        primary key,
    Amount      int         not null,
    ChargeDate  datetime(6) not null,
    IsActive    tinyint(1)  not null,
    TypeID      int         not null,
    CommunityID int         not null,
    UserId      int         not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Charges_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_Charges_ChargeTypes_TypeID
        foreign key (TypeID) references ChargeTypes (ID)
            on delete cascade,
    constraint FK_Charges_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade
);

create index IX_Charges_CommunityID
    on Charges (CommunityID);

create index IX_Charges_TypeID
    on Charges (TypeID);

create index IX_Charges_UserId
    on Charges (UserId);

create table CommonSpaces
(
    ID              int auto_increment
        primary key,
    Name            longtext    not null,
    Capacity        int         not null,
    Location        longtext    not null,
    CommunityId     int         not null,
    IsInMaintenance tinyint(1)  not null,
    CreatedAt       datetime(6) not null,
    UpdatedAt       datetime(6) not null,
    IsDeleted       tinyint(1)  not null,
    constraint FK_CommonSpaces_Community_CommunityId
        foreign key (CommunityId) references Community (ID)
            on delete cascade
);

create index IX_CommonSpaces_CommunityId
    on CommonSpaces (CommunityId);

create index IX_Community_MunicipalityID
    on Community (MunicipalityID);

create table CommunityUser
(
    CommunitiesID int not null,
    UsersId       int not null,
    primary key (CommunitiesID, UsersId),
    constraint FK_CommunityUser_AspNetUsers_UsersId
        foreign key (UsersId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_CommunityUser_Community_CommunitiesID
        foreign key (CommunitiesID) references Community (ID)
            on delete cascade
);

create index IX_CommunityUser_UsersId
    on CommunityUser (UsersId);

create table Contacts
(
    ID          int auto_increment
        primary key,
    FirstName   longtext    not null,
    LastName    longtext    not null,
    Email       longtext    not null,
    PhoneNumber longtext    not null,
    Service     longtext    not null,
    CommunityID int         not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Contacts_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade
);

create index IX_Contacts_CommunityID
    on Contacts (CommunityID);

create table Expense
(
    ID          int auto_increment
        primary key,
    Amount      int         not null,
    Date        datetime(6) not null,
    TypeID      int         not null,
    CommunityID int         not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Expense_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade,
    constraint FK_Expense_ExpenseTypes_TypeID
        foreign key (TypeID) references ExpenseTypes (ID)
            on delete cascade
);

create index IX_Expense_CommunityID
    on Expense (CommunityID);

create index IX_Expense_TypeID
    on Expense (TypeID);

create table Fine
(
    ID          int auto_increment
        primary key,
    Name        longtext       not null,
    Amount      decimal(18, 2) not null,
    Status      int            not null,
    CommunityID int            not null,
    CreatedAt   datetime(6)    not null,
    UpdatedAt   datetime(6)    not null,
    IsDeleted   tinyint(1)     not null,
    constraint FK_Fine_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade
);

create index IX_Fine_CommunityID
    on Fine (CommunityID);

create table Maintenances
(
    ID            int auto_increment
        primary key,
    StartDate     datetime(6) not null,
    EndDate       datetime(6) not null,
    Comment       longtext    not null,
    CommonSpaceID int         not null,
    IsActive      tinyint(1)  not null,
    CommunityID   int         not null,
    CreatedAt     datetime(6) not null,
    UpdatedAt     datetime(6) not null,
    IsDeleted     tinyint(1)  not null,
    constraint FK_Maintenances_CommonSpaces_CommonSpaceID
        foreign key (CommonSpaceID) references CommonSpaces (ID)
            on delete cascade,
    constraint FK_Maintenances_Community_CommunityID
        foreign key (CommunityID) references Community (ID)
            on delete cascade
);

create index IX_Maintenances_CommonSpaceID
    on Maintenances (CommonSpaceID);

create index IX_Maintenances_CommunityID
    on Maintenances (CommunityID);

create index IX_Municipality_CityID
    on Municipality (CityID);

create table Package
(
    ID               int auto_increment
        primary key,
    TrackingNumber   longtext    not null,
    ReceptionDate    datetime(6) not null,
    Status           int         not null,
    CommunityId      int         not null,
    RecipientId      int         not null,
    ConciergeId      int         not null,
    CreatedAt        datetime(6) not null,
    UpdatedAt        datetime(6) not null,
    IsDeleted        tinyint(1)  not null,
    DeliveredToId    int         null,
    DeliveredDate    datetime(6) null,
    NotificationDate datetime    null,
    NotificacionSent int         null,
    CanRetireId      int         null,
    constraint FK_Package_AspNetUsers_ConciergeId
        foreign key (ConciergeId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_Package_AspNetUsers_DeliveredToId
        foreign key (DeliveredToId) references AspNetUsers (Id),
    constraint FK_Package_AspNetUsers_RecipientId
        foreign key (RecipientId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_Package_Community_CommunityId
        foreign key (CommunityId) references Community (ID)
            on delete cascade
);

create index IX_Package_CanRetireId
    on Package (CanRetireId);

create index IX_Package_CommunityId
    on Package (CommunityId);

create index IX_Package_ConciergeId
    on Package (ConciergeId);

create index IX_Package_DeliveredToId
    on Package (DeliveredToId);

create index IX_Package_RecipientId
    on Package (RecipientId);

create table Payment
(
    ID          int auto_increment
        primary key,
    Amount      int         not null,
    PaymentDate datetime(6) not null,
    PaymentType int         not null,
    URL         longtext    not null,
    ChargeID    int         not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Payment_Charges_ChargeID
        foreign key (ChargeID) references Charges (ID)
            on delete cascade
);

create index IX_Payment_ChargeID
    on Payment (ChargeID);

create table Pets
(
    ID          int auto_increment
        primary key,
    UserId      int         not null,
    CommunityId int         not null,
    Name        longtext    not null,
    Species     longtext    not null,
    BirthDate   datetime(6) not null,
    PhotoUrl    longtext    not null,
    IsActive    tinyint(1)  not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_Pets_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_Pets_Community_CommunityId
        foreign key (CommunityId) references Community (ID)
            on delete cascade
);

create index IX_Pets_CommunityId
    on Pets (CommunityId);

create index IX_Pets_UserId
    on Pets (UserId);

create table Reservations
(
    ID                int auto_increment
        primary key,
    Date              datetime(6) not null,
    StartTime         time(6)     not null,
    EndTime           time(6)     not null,
    Status            int         not null,
    ConfirmationToken longtext    not null,
    ExpirationDate    datetime(6) not null,
    UserId            int         not null,
    SpaceId           int         not null,
    CreatedAt         datetime(6) not null,
    UpdatedAt         datetime(6) not null,
    IsDeleted         tinyint(1)  not null,
    constraint FK_Reservations_AspNetUsers_UserId
        foreign key (UserId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_Reservations_CommonSpaces_SpaceId
        foreign key (SpaceId) references CommonSpaces (ID)
            on delete cascade
);

create table Attendees
(
    ID            int auto_increment
        primary key,
    Name          longtext    not null,
    Email         longtext    not null,
    Rut           longtext    not null,
    ReservationId int         not null,
    CreatedAt     datetime(6) not null,
    UpdatedAt     datetime(6) not null,
    IsDeleted     tinyint(1)  not null,
    constraint FK_Attendees_Reservations_ReservationId
        foreign key (ReservationId) references Reservations (ID)
            on delete cascade
);

create index IX_Attendees_ReservationId
    on Attendees (ReservationId);

create index IX_Reservations_SpaceId
    on Reservations (SpaceId);

create index IX_Reservations_UserId
    on Reservations (UserId);

create table ShiftTypes
(
    ID          int auto_increment
        primary key,
    Description longtext    not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null
);

create table Shifts
(
    ID        int auto_increment
        primary key,
    ClockIn   time        not null,
    ClockOut  time        not null,
    TypeID    int         not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null,
    constraint FK_Shifts_ShiftTypes_TypeID
        foreign key (TypeID) references ShiftTypes (ID)
            on delete cascade
);

create table AssignedShifts
(
    ID          int auto_increment
        primary key,
    ShiftId     int         not null,
    StaffId     int         not null,
    CommunityId int         not null,
    StartDate   datetime(6) not null,
    EndDate     datetime(6) not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null,
    constraint FK_AssignedShifts_Shifts_ShiftId
        foreign key (ShiftId) references Shifts (ID)
            on delete cascade
);

create table AssignedShiftCommunity
(
    AssignedShiftsID int not null,
    CommunitiesID    int not null,
    primary key (AssignedShiftsID, CommunitiesID),
    constraint FK_AssignedShiftCommunity_AssignedShifts_AssignedShiftsID
        foreign key (AssignedShiftsID) references AssignedShifts (ID)
            on delete cascade,
    constraint FK_AssignedShiftCommunity_Community_CommunitiesID
        foreign key (CommunitiesID) references Community (ID)
            on delete cascade
);

create index IX_AssignedShiftCommunity_CommunitiesID
    on AssignedShiftCommunity (CommunitiesID);

create table AssignedShiftUser
(
    AssignedShiftsID int not null,
    UsersId          int not null,
    primary key (AssignedShiftsID, UsersId),
    constraint FK_AssignedShiftUser_AspNetUsers_UsersId
        foreign key (UsersId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_AssignedShiftUser_AssignedShifts_AssignedShiftsID
        foreign key (AssignedShiftsID) references AssignedShifts (ID)
            on delete cascade
);

create index IX_AssignedShiftUser_UsersId
    on AssignedShiftUser (UsersId);

create index IX_AssignedShifts_ShiftId
    on AssignedShifts (ShiftId);

create index IX_Shifts_TypeID
    on Shifts (TypeID);

create table TemplateNotifications
(
    ID                  int auto_increment
        primary key,
    Name                longtext    not null,
    TemplateId          longtext    not null,
    DynamicTemplateName longtext    not null,
    CreatedAt           datetime(6) not null,
    UpdatedAt           datetime(6) not null,
    IsDeleted           tinyint(1)  not null
);

create table UnitTypes
(
    ID          int auto_increment
        primary key,
    Description longtext    not null,
    CreatedAt   datetime(6) not null,
    UpdatedAt   datetime(6) not null,
    IsDeleted   tinyint(1)  not null
);

create table Units
(
    ID         int auto_increment
        primary key,
    Number     longtext    not null,
    Floor      int         not null,
    Surface    float       not null,
    BuildingID int         not null,
    UnitTypeID int         not null,
    CreatedAt  datetime(6) not null,
    UpdatedAt  datetime(6) not null,
    IsDeleted  tinyint(1)  not null,
    constraint FK_Units_Buildings_BuildingID
        foreign key (BuildingID) references Buildings (ID)
            on delete cascade,
    constraint FK_Units_UnitTypes_UnitTypeID
        foreign key (UnitTypeID) references UnitTypes (ID)
            on delete cascade
);

create table Guest
(
    ID        int auto_increment
        primary key,
    FirstName longtext    not null,
    LastName  longtext    not null,
    Rut       longtext    not null,
    Plate     longtext    not null,
    EntryTime datetime(6) not null,
    UnitId    int         not null,
    CreatedAt datetime(6) not null,
    UpdatedAt datetime(6) not null,
    IsDeleted tinyint(1)  not null,
    constraint FK_Guest_Units_UnitId
        foreign key (UnitId) references Units (ID)
            on delete cascade
);

create index IX_Guest_UnitId
    on Guest (UnitId);

create table UnitUser
(
    UnitsID int not null,
    UsersId int not null,
    primary key (UnitsID, UsersId),
    constraint FK_UnitUser_AspNetUsers_UsersId
        foreign key (UsersId) references AspNetUsers (Id)
            on delete cascade,
    constraint FK_UnitUser_Units_UnitsID
        foreign key (UnitsID) references Units (ID)
            on delete cascade
);

create index IX_UnitUser_UsersId
    on UnitUser (UsersId);

create index IX_Units_BuildingID
    on Units (BuildingID);

create index IX_Units_UnitTypeID
    on Units (UnitTypeID);

create table __EFMigrationsHistory
(
    MigrationId    varchar(150) not null
        primary key,
    ProductVersion varchar(32)  not null
);


