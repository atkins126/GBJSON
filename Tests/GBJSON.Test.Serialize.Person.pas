unit GBJSON.Test.Serialize.Person;

interface

uses
  DUnitX.TestFramework,
  GBJSON.Test.Models,
  GBJSON.Interfaces,
  GBJSON.Helper,
  GBJSON.Deserializer,
  GBJSON.Serializer,
  System.JSON,
  System.SysUtils;

type TGBJSONTestSerializePerson = class

  private
    FPerson      : TPerson;
    FAuxPerson   : TPerson;
    FUpperPerson : TUpperPerson;
    FDeserialize : IGBJSONDeserializer<TPerson>;
    FSerialize   : IGBJSONSerializer<TPerson>;
    FJSONObject  : TJSONObject;

    function GetJsonObject(APerson: TPerson): TJSONObject;
  public
    [Setup]    procedure Setup;
    [TearDown] procedure TearDown;

    [Test] procedure TestStringName;
    [Test] procedure TestStringEmpty;
    [Test] procedure TestStringWithAccent;
    [Test] procedure TestStringWithBar;
    [Test] procedure TestStringWithBackslash;

    [Test] procedure TestIntegerPositive;
    [Test] procedure TestIntegerEmpty;
    [Test] procedure TestIntegerNegative;

    [Test] procedure TestFloatPositive;
    [Test] procedure TestFloatNegative;
    [Test] procedure TestFloatZero;
    [Test] procedure TestFloatPositiveWithDecimal;
    [Test] procedure TestFloatNegativeWithDecimal;

    [Test] procedure TestDateEmpty;
    [Test] procedure TestDateFill;

    [Test] procedure TestBooleanFalse;
    [Test] procedure TestBooleanTrue;
    [Test] procedure TestBoolEmpty;

    [Test] procedure TestEnumString;

    [Test] procedure TestObjectValue;
    [Test] procedure TestObjectNull;

    [Test] procedure TestObjectLowerCase;
    [Test] procedure TestObjectUpperCase;

    [Test] procedure TestObjectListFill;
    [Test] procedure TestObjectListEmpty;
    [Test] procedure TestObjectListOneElement;
    [Test] procedure TestObjectListNull;

    constructor create;
    destructor  Destroy; override;
end;

implementation

{ TGBJSONTestSerializePerson }

constructor TGBJSONTestSerializePerson.create;
begin
  FDeserialize := TGBJSONDeserializer<TPerson>.New(False);
  FSerialize   := TGBJSONSerializer<TPerson>.New(False);
end;

destructor TGBJSONTestSerializePerson.Destroy;
begin
  inherited;
end;

function TGBJSONTestSerializePerson.GetJsonObject(APerson: TPerson): TJSONObject;
begin
  FreeAndNil(FJSONObject);
  FJSONObject := FDeserialize.ObjectToJsonObject(APerson);

  result := FJSONObject;
end;

procedure TGBJSONTestSerializePerson.Setup;
begin
  FPerson     := TPerson.CreatePerson;
  FJSONObject := GetJsonObject(FPerson);
end;

procedure TGBJSONTestSerializePerson.TearDown;
begin
  FreeAndNil(FJSONObject);
  FreeAndNil(FUpperPerson);
  FreeAndNil(FPerson);
  FreeAndNil(FAuxPerson);
end;

procedure TGBJSONTestSerializePerson.TestBooleanFalse;
begin
  FPerson.active := False;
  FJSONObject   := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsFalse(FAuxPerson.active);
end;

procedure TGBJSONTestSerializePerson.TestBooleanTrue;
begin
  FPerson.active := True;
  FJSONObject   := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsTrue(FAuxPerson.active);
end;

procedure TGBJSONTestSerializePerson.TestBoolEmpty;
begin
  FPerson.active := True;
  FJSONObject   := GetJsonObject(FPerson);
  FJSONObject.RemovePair('active').Free;

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsFalse(FAuxPerson.active);
end;

procedure TGBJSONTestSerializePerson.TestDateFill;
begin
  FPerson.creationDate := Now;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FormatDateTime('yyyy-MM-dd hh:mm:ss', FPerson.creationDate),
                  FormatDateTime('yyyy-MM-dd hh:mm:ss', FAuxPerson.creationDate));
end;

procedure TGBJSONTestSerializePerson.TestDateEmpty;
begin
  FPerson.creationDate := 0;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.creationDate, FAuxPerson.creationDate);
end;

procedure TGBJSONTestSerializePerson.TestEnumString;
begin
  FPerson.personType := tpJuridica;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.personType, FAuxPerson.personType);
end;

procedure TGBJSONTestSerializePerson.TestFloatNegative;
begin
  FPerson.average := -5;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.average, FAuxPerson.average);
end;

procedure TGBJSONTestSerializePerson.TestFloatNegativeWithDecimal;
begin
  FPerson.average := -5.25;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.average, FAuxPerson.average);
end;

procedure TGBJSONTestSerializePerson.TestFloatPositive;
begin
  FPerson.average := 15;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.average, FAuxPerson.average);
end;

procedure TGBJSONTestSerializePerson.TestFloatPositiveWithDecimal;
begin
  FPerson.average := 15.351;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.average, FAuxPerson.average);
end;

procedure TGBJSONTestSerializePerson.TestFloatZero;
begin
  FPerson.average := 0;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsTrue(FAuxPerson.average = 0);
end;

procedure TGBJSONTestSerializePerson.TestIntegerNegative;
begin
  FPerson.age := -5;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.age, FAuxPerson.age);
end;

procedure TGBJSONTestSerializePerson.TestIntegerPositive;
begin
  FPerson.age := 50;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.age, FAuxPerson.age);
end;

procedure TGBJSONTestSerializePerson.TestIntegerEmpty;
begin
  FPerson.age := 0;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.age, FAuxPerson.age);
end;

procedure TGBJSONTestSerializePerson.TestObjectListFill;
begin
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsTrue (FAuxPerson.phones.Count > 0);
  Assert.IsFalse(FAuxPerson.phones[0].number.IsEmpty);

  Assert.AreEqual(FPerson.phones.Count, FAuxPerson.phones.Count);
  Assert.AreEqual(FPerson.phones[0].number, FAuxPerson.phones[0].number);
end;

procedure TGBJSONTestSerializePerson.TestObjectListNull;
begin
  FPerson.phones.Free;
  FPerson.phones := nil;

  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson.phones);
  Assert.IsTrue (FAuxPerson.phones.Count = 0);
end;

procedure TGBJSONTestSerializePerson.TestObjectListOneElement;
begin
  FPerson.phones.Remove(FPerson.phones[1]);
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsTrue (FAuxPerson.phones.Count = 1);
  Assert.IsFalse(FAuxPerson.phones[0].number.IsEmpty);

  Assert.AreEqual(FPerson.phones.Count, FAuxPerson.phones.Count);
  Assert.AreEqual(FPerson.phones[0].number, FAuxPerson.phones[0].number);
end;

procedure TGBJSONTestSerializePerson.TestObjectLowerCase;
begin
  FreeAndNil(FJSONObject);
  FJSONObject := TJSONObject.Create;
  FJSONObject
    .AddPair('person_id', TJSONNumber.Create(1))
    .AddPair('person_name', 'Person Test');

  TGBJSONConfig.GetInstance
    .CaseDefinition(TCaseDefinition.cdLower);

  FUpperPerson := TUpperPerson.create;
  FUpperPerson.fromJSONObject(FJSONObject);

  Assert.AreEqual('1', FUpperPerson.PERSON_ID.ToString);
  Assert.AreEqual('Person Test', FUpperPerson.PERSON_NAME);
end;

procedure TGBJSONTestSerializePerson.TestObjectListEmpty;
begin
  FPerson.phones.Remove(FPerson.phones[0]);
  FPerson.phones.Remove(FPerson.phones[0]);

  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsTrue (FAuxPerson.phones.Count = 0);
end;

procedure TGBJSONTestSerializePerson.TestObjectNull;
begin
  FPerson.address.Free;
  FPerson.address := nil;

  FJSONObject := GetJsonObject(FPerson);
  FAuxPerson  := FSerialize.JsonObjectToObject(FJSONObject);

  Assert.IsEmpty(FAuxPerson.address.street);
end;

procedure TGBJSONTestSerializePerson.TestObjectUpperCase;
begin
  FreeAndNil(FPerson);
  FreeAndNil(FJSONObject);
  FJSONObject := TJSONObject.Create;
  FJSONObject
    .AddPair('IDPERSON', TJSONNumber.Create(1))
    .AddPair('NAME', 'Person Test');

  TGBJSONConfig.GetInstance
    .CaseDefinition(TCaseDefinition.cdUpper);

  FPerson := TPerson.Create;
  FPerson.fromJSONObject(FJSONObject);

  Assert.AreEqual('1', FPerson.idPerson.ToString);
  Assert.AreEqual('Person Test', FPerson.name);
end;

procedure TGBJSONTestSerializePerson.TestObjectValue;
begin
  FPerson.address.street := 'Rua Tal';
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.AreEqual(FPerson.address.street, FAuxPerson.address.street);
end;

procedure TGBJSONTestSerializePerson.TestStringWithAccent;
begin
  FPerson.name := 'Tom�';
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson);
  Assert.AreEqual(FPerson.name, FAuxPerson.name);
end;

procedure TGBJSONTestSerializePerson.TestStringWithBar;
begin
  FPerson.name := 'Value 1 / Value 2';
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson);
  Assert.AreEqual(FPerson.name, FAuxPerson.name);
end;

procedure TGBJSONTestSerializePerson.TestStringWithBackslash;
begin
  FPerson.name := 'Value 1 \ Value 2';
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson);
  Assert.AreEqual(FPerson.name, FAuxPerson.name);
end;

procedure TGBJSONTestSerializePerson.TestStringEmpty;
begin
  FPerson.name := EmptyStr;
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson);
  Assert.AreEqual(FPerson.name, FAuxPerson.name);
end;

procedure TGBJSONTestSerializePerson.TestStringName;
begin
  FPerson.name := 'Value 1';
  FJSONObject := GetJsonObject(FPerson);

  FAuxPerson := FSerialize.JsonObjectToObject(FJSONObject);
  Assert.IsNotNull(FAuxPerson);
  Assert.AreEqual(FPerson.name, FAuxPerson.name);
end;

end.
