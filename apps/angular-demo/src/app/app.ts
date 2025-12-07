import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { NxWelcome } from './nx-welcome';
// importing the component from the library
import { Hero } from '@angular-demo/ui';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule, NxWelcome, Hero],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {
  protected title = 'angular-demo';
}
