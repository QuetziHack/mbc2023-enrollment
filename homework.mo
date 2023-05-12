import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Time "mo:base/Time";


import Type "Types";
//import Homework "homework";

actor class Homework() {
  type Time = Time.Time;
  type Homework = Type.Homework;
  type Buffer<Homework> = Buffer.Buffer<Homework>;

  var idCounter: Nat = 0;

  let homeworDiary : Buffer<Homework> = Buffer.Buffer<Homework>(0);
  // Add a new homework task
  public shared func addHomework(homework : Homework) : async Nat {
    
    homeworDiary.add(homework);

    idCounter+=1;
    return idCounter-1;
  };

  // Get a specific homework task by id
  public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {

    if (id > homeworDiary.size()) {
      #err("no se pudo u.u");
    }else{
      let hw = homeworDiary.get(id);
      #ok(hw);
    }

  };

  // Update a homework task's title, description, and/or due date
  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    if (id > homeworDiary.size()) {
      #err("no se pudo u.u");
    }else{
      homeworDiary.put(id,homework);
      #ok();
    }
  };

  // Mark a homework task as completed
  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    
    if (id > homeworDiary.size()) {
      #err("no se pudo u.u");
    }else{
      let hw = homeworDiary.get(id);
      let updH: Homework = {
        title: Text = hw.title;
        description: Text = hw.description;
        dueDate: Time = hw.dueDate;
        completed: Bool = true;
      };
      homeworDiary.put(id,updH);
      #ok();
    }
  };

  // Delete a homework task by id
  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    if (id > homeworDiary.size()) {
      #err("no se pudo u.u");
    }else{
      let hw = homeworDiary.remove(id);
      #ok();
    }
  };

  // Get the list of all homework tasks
  public shared query func getAllHomework() : async [Homework] {
    return Buffer.toArray(homeworDiary);
  };

  // Get the list of pending (not completed) homework tasks
  public shared query func getPendingHomework() : async [Homework] {
    let pend =  Buffer.Buffer<Homework>(0);
    for (hw in homeworDiary.vals()){
      if(not hw.completed ){
        pend.add(hw);
      };

    };
    return Buffer.toArray(pend);
  };

  // Search for homework tasks based on a search terms
  public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    let hwTerm =  Buffer.Buffer<Homework>(0);
    for (hw in homeworDiary.vals()){
      if(hw.title == searchTerm ){
        hwTerm.add(hw);
      };

    };
    return Buffer.toArray(hwTerm);
  };
};
