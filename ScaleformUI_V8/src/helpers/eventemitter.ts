export interface IDelegate {
    (...parameters: any[]): Promise<any>;
}

export class DelegateBuilder {
    private callees: IDelegate[];

    constructor() {
        this.callees = [];
    }

    invoke(...parameters: any[]) {
        this.callees.forEach(callee => callee && callee(...parameters));
    }

    contains(callee: IDelegate) : boolean {
        return !!callee && this.callees.includes(callee);
    }

    add(callee: IDelegate): DelegateBuilder {
        if (callee && !this.contains(callee)) {
            this.callees.push(callee);
        }
        return this;
    }

    remove(callee: IDelegate): DelegateBuilder {
        const index = this.callees.indexOf(callee);
        if (index >= 0) {
            this.callees.splice(index, 1);
        }
        return this;
    }

    clear(){
        this.callees.length = 0;
    }

    toDelegate() : IDelegate {
        return async (...parameters: any[]) => this.invoke(...parameters);
    }
}