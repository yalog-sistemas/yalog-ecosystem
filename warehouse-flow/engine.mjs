/* Warehouse Flow WF-003 — pure domain logic, no persistence and no production dependencies. */
export const STAGES=Object.freeze({
 inbound:Object.freeze(['gate','receiving','inbound_check','putaway']),
 outbound:Object.freeze(['picking','outbound_check','palletizing','shipping','loading'])
});
export const STATES=Object.freeze(['planned','ready','in_progress','paused','blocked','completed','cancelled']);
const TRANSITIONS=Object.freeze({
 planned:['ready','cancelled'],ready:['in_progress','blocked','cancelled'],
 in_progress:['paused','blocked','completed'],paused:['in_progress','blocked','cancelled'],
 blocked:['ready','cancelled'],completed:[],cancelled:[]
});
export function transition(task,to,{actor,reason='',at=new Date().toISOString()}={}){
 if(!task||!STATES.includes(task.status))throw Error('Invalid task');
 if(!TRANSITIONS[task.status].includes(to))throw Error('Transition not allowed');
 if(!actor)throw Error('Actor required');
 if(['blocked','cancelled'].includes(to)&&!reason.trim())throw Error('Reason required');
 const next={...task,status:to,updated_at:at};
 if(to==='in_progress'&&!next.started_at)next.started_at=at;
 if(to==='completed')next.completed_at=at;
 return {task:next,event:{event_id:crypto.randomUUID(),task_id:task.id,from:task.status,to,actor,reason,occurred_at:at}};
}
export function canStart(task,allTasks){
 if(task.status!=='ready')return false;
 return (task.depends_on||[]).every(id=>allTasks.some(t=>t.id===id&&t.status==='completed'));
}
export function createOperation({id,company_id,unit_id,direction,reference}){
 if(!id||!company_id||!unit_id||!reference?.trim()||!STAGES[direction])throw Error('Invalid operation');
 return {id,company_id,unit_id,direction,reference:reference.trim(),status:'planned',created_at:new Date().toISOString()};
}
export function createTasks(operation){
 return STAGES[operation.direction].map((stage,index,arr)=>({
 id:operation.id+':'+stage,operation_id:operation.id,company_id:operation.company_id,
 unit_id:operation.unit_id,stage,status:index===0?'ready':'planned',
 depends_on:index===0?[]:[operation.id+':'+arr[index-1]]
 }));
}
export function eventKey(e){if(!e?.tenant_id||!e?.source||!e?.event_id)throw Error('Invalid event');return [e.tenant_id,e.source,e.event_id].join(':')}
