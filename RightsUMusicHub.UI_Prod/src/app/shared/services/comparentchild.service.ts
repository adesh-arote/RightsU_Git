import { Injectable } from '@angular/core';
import { Observable,Subject } from 'rxjs';
import { BaseService } from './base.service'
 
@Injectable()
export class ComParentChildService {
 
// private subjects: Subject[] = [];
  constructor(private _baseservice: BaseService) {

  }
 
publish(eventName: string) {
// ensure a subject for the event name exists
Subject[eventName] = Subject[eventName] || new Subject();
 
// publish event
Subject[eventName].next();
}
 
on(eventName: string): Observable<any> {
// ensure a subject for the event name exists
Subject[eventName] = Subject[eventName] || new Subject();
 
// return observable
return Subject[eventName].asObservable();
}
 
}
