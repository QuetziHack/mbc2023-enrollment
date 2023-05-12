import Result "mo:base/Result";
import List "mo:base/List";

import Type "Types";
import Homework "Types";

actor class homework() {
  type Homework = Type.Homework;
  type List<Homework> = ?(Homework,List<Homework>);
  
  var homeworkDiary : List<Homework> = List.nil();
  var idCounter : Nat = 0;
 
  // Add a new homework task
  public shared func addHomework(homework : Homework) : async Nat {      
    
    //let newList : [Text] = myList # ["nuevoElemento"];  // Agregar un nuevo elemento a la lista original
    homeworkDiary := List.push(homework,homeworkDiary);

    idCounter +=1;
    return idCounter-1;
  };

  // Get a specific homework task by id
  public shared query func getHomework(id : Nat) : async Result.Result<?Homework, Text> {    
    let hw = List.get(homeworkDiary,id);
    if (id > List.size(homeworkDiary)) {
      #err("no se pudo u.u");
    }else{
      #ok(hw);
    }    
  };

  // Update a homework task's title, description, and/or due date
  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    if (id > List.size(homeworkDiary)) {
      #err("no se pudo u.u");
    }else{
      #ok();
    }
  };

  // Mark a homework task as completed
  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    return #err("not implemented");
  };

  // Delete a homework task by id
  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    return #err("not implemented");
  };

  // Get the list of all homework tasks
  public shared query func getAllHomework() : async [Homework] {
    return [];
  };

  // Get the list of pending (not completed) homework tasks
  public shared query func getPendingHomework() : async [Homework] {
    return [];
  };

  // Search for homework tasks based on a search terms
  public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    return [];
  };
};