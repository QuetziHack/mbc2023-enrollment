import Type "Types";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";

actor class StudentWall() {
  type Message = Type.Message;
  type Content = Type.Content;
  type Survey = Type.Survey;
  type Answer = Type.Answer;
  
  var messageId: Nat = 0;

  let wall = HashMap.HashMap<Nat, Message>(1,Nat.equal,Hash.hash);

  // Add a new message to the wall
  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
  
    let newMess: Message = {
      content = c;
      vote = 0;
      creator = caller;
    };
    wall.put(messageId,newMess);
    messageId+=1;
    return messageId-1;
  };

  // Get a specific message by ID
  public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {
    let mess: ?Message = wall.get(messageId);
    switch(mess){
      case(null){
        #err "No se pudo, el index anda mal, ni pps";
      };
      case(?curMess){
        let mess2: Message = {
          content = curMess.content;
          vote = curMess.vote;
          creator = curMess.creator;
        }; 
        #ok(mess2);
      }; 
    };
  };

  // Update the content for a specific message by ID
  public shared ({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
    let mess = wall.get(messageId);
    switch(mess){
      case(null){
        #err "No se pudo, el index anda mal, ni pps";
      };
      case(?curMess){
        if(Principal.equal(curMess.creator, caller)){
          let msg:Message = {
            content = c;
            vote = curMess.vote;
            creator = curMess.creator;
          };
          wall.put(messageId,msg);
          return #ok();

        };
        #err "No se pudo, tú no eres el dueño, mañoso, ni pps";

      }; 
    };
  };

  // Delete a specific message by ID
  public shared ({ caller }) func deleteMessage(messageId : Nat) : async Result.Result<(), Text> {
    let mess = wall.get(messageId);
    switch(mess){
      case(null){
        #err "No se pudo, el index anda mal, ni pps";
      };
      case(?curMess){
        wall.delete(messageId);
        #ok ();
      }; 
    };
  };

  // Voting
  public func upVote(messageId : Nat) : async Result.Result<(), Text> {
    let mess = wall.get(messageId);
    switch(mess){
      case(null){
        #err "No se pudo, el index anda mal, ni pps";
      };
      case(?curMess){
        let msg:Message = {
          content = curMess.content;
          vote = curMess.vote+1;
          creator = curMess.creator;
        };
        wall.put(messageId,msg);
        #ok ();
      }; 
    };
  };

  public func downVote(messageId : Nat) : async Result.Result<(), Text> {
    let mess = wall.get(messageId);
    switch(mess){
      case(null){
        #err "No se pudo, el index anda mal, ni pps";
      };
      case(?curMess){
        let msg:Message = {
          content = curMess.content;
          vote = curMess.vote-1;
          creator = curMess.creator;
        };
        wall.put(messageId,msg);
        #ok ();
      }; 
    };
  };

  // Get all messages
  public func getAllMessages() : async [Message] {
    let iter : Iter.Iter<Message> = wall.vals();
    Iter.toArray<Message>(iter);
  };

  // Get all messages ordered by votes
  public func getAllMessagesRanked() : async [Message] {
    let iter : Iter.Iter<Message> = wall.vals();
    Array.sort<Message>(Iter.toArray<Message>(iter), Type.compareMess);
    
  };
};
