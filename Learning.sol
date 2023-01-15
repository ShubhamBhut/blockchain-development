//

//solidity is very similar to python and js
//It is a contract oriented language, quite similar to object oriented. It is also static language means types of all variables must be declared first


//first thing is to define the version of solidity
//It can also be defined in range eg. >=0.6.1 <0.8.0
pragma solidity ^0.6.6; //this indicates use of a specific version of solidity

contract Learning {

    string value;
    
    //the code inside constructor will get executed before any other code inside the contract
    constructor() public {
        value = "Default value";
        state = State.Waiting;
    }

    // the following is function in solidity. public is the visibility status, view is type of action, check docs for more info
    function get() public view returns(string memory){
        return value;
    }

    //following function will set the value of variabe value of datatype string, memory stands for storage type
    function set(string memory _value) public {
        value = _value;
    }

 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

    //dataypes 
    string public mystring = "this is my string";
    bool public mybool = true;
    int public myint = -1;
    uint256 public myuint = 1; 
    //unit can't have sign means can't be negative

    //enum is enumerated list that is used to keep tracks of things in contract
    enum State { Waiting, Ready, Active} //all 3 are states of contract
    State public state;
    function activate() public {
        state = State.Active;
    }

    //function to check if state is active or not
    function isActive() public view returns(bool) {
        return state == State.Active;
    }

    //structs are custom data structures
    struct Person {
        string _firstName;
        string _lastName;
    }

    Person[] public people; //shows an array names people filled with data structure Person
    
    function addPerson(string memory _firstName, string memory _lastName) public {
        peopleCount +=1;
        people.push(Person(_firstName, _lastName));
    }

//Point to note here is that, unlike python solidity doesn't know the size of dynamic array hence entire array
//can not be accessed, only array members can be accessed by their id (index), quite same to c++

    uint256 public peopleCount;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //mapping
    //mapping is also a data structure but very important here. its like a key,value pair

    mapping(uint256 => Person) public people_mapping;

}
