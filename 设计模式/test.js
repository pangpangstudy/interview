class Subject {
  constructor() {
    this.state = "开心";
    this.observers = [];
  }
  attach(ther) {
    this.observers.push(ther);
  }
}
class Observer {
  constructor(name) {
    this.name = name;
  }
}
let baby = new Subject("小宝宝");
let father = new Observer("baba");
let mother = new Observer("mama");
baby.attach(father);
baby.attach(mother);
