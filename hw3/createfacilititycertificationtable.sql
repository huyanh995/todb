CREATE TABLE cse532.facilitycertification(
    FacilityID          VARCHAR(16) NOT NULL -- Not primary key bcs one facility may have multiple certifications
    ,FacilityName       VARCHAR(128)
    ,Description        VARCHAR(128)
    ,AttributeType      VARCHAR(16)
    ,AttributeValue     VARCHAR(128)
    ,MeasureValue       FLOAT
    ,County             VARCHAR(16)
);
