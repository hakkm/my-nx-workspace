import { Component, inject } from '@angular/core';
import { RouterModule } from '@angular/router';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule, HttpClientModule, NgIf],
  template: `
    <h1>{{ title }}</h1>

    <div *ngIf="helloData; else loading">
      <p>{{ helloData.message }}</p>
      <p>{{ helloData.timestamp }}</p>
      <p>{{ helloData.status }}</p>
    </div>

    <ng-template #loading>
      <p>Backend is making coffee...</p>
    </ng-template>
  `,
  styles: [
    `
      h1 {
        color: #4c7;
        font-size: 28px;
      }
      p {
        font-size: 18px;
      }
    `,
  ],
})
export class App {
  private http = inject(HttpClient);
  protected title = 'angular-demo';
  protected helloData?: HelloResponse;

  constructor() {
    this.fetchHello();
  }

  private fetchHello() {
    this.http
      .get<HelloResponse>('http://localhost:8080/api/test/hello')
      .subscribe({
        next: (data) => (this.helloData = data),
        error: (err) => console.error('Backend exploded:', err),
      });
  }
}

interface HelloResponse {
  message: string;
  timestamp: string;
  status: string;
}
