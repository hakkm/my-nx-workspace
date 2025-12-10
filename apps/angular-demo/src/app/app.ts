import { Component, inject } from '@angular/core';
import { RouterModule } from '@angular/router';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { NgIf, NgFor, CurrencyPipe } from '@angular/common';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule, HttpClientModule, NgIf, NgFor, CurrencyPipe],
  template: `
    <h1>{{ title }}</h1>

    <div *ngIf="error" style="color: #c44">{{ error }}</div>

    <div *ngIf="products; else loading">
      <h2>Products</h2>
      <ul>
        <li *ngFor="let p of products">
          <strong>#{{ p.id }}</strong>
          <span>{{ p.name }}</span>
          <span>- {{ p.price | currency:'USD':'symbol' }}</span>
        </li>
      </ul>

      <h3>Add a product</h3>
      <form (submit)="addProduct(nameInput.value, priceInput.value); nameInput.value=''; priceInput.value=''; $event.preventDefault()">
        <label>
          Name:
          <input #nameInput type="text" placeholder="e.g. Bamboo Chair" required />
        </label>
        <label style="margin-left:12px">
          Price:
          <input #priceInput type="number" step="0.01" placeholder="e.g. 99.99" required />
        </label>
        <button type="submit" style="margin-left:12px">Add</button>
      </form>
    </div>

    <ng-template #loading>
      <p>Loading products from backend...</p>
    </ng-template>
  `,
  styles: [
    `
      h1 {
        color: #4c7;
        font-size: 28px;
      }
      p, li, label, input, button {
        font-size: 16px;
      }
      ul { list-style: none; padding-left: 0; }
      li { margin: 6px 0; }
      form { margin-top: 12px; }
    `,
  ],
})
export class App {
  private readonly http = inject(HttpClient);
  protected title = 'angular-demo';
  protected products?: Product[];
  protected error?: string;

  constructor() {
    this.fetchProducts();
  }

  private fetchProducts() {
    const url = `${environment.apiBaseUrl}/products`;
    this.http.get<Product[]>(url).subscribe({
      next: (data) => (this.products = data),
      error: (err) => {
        console.error('Failed to fetch products:', err);
        this.error = 'Failed to load products.';
      },
    });
  }

  addProduct(name: string, priceStr: string) {
    const price = Number(priceStr);
    if (!name || Number.isNaN(price)) {
      this.error = 'Please provide a valid name and price.';
      return;
    }

    const url = `${environment.apiBaseUrl}/products`;
    const payload: NewProduct = { name, price };
    this.http.post<Product>(url, payload).subscribe({
      next: (saved) => {
        // Optimistically update list
        this.products = [...(this.products ?? []), saved];
        this.error = undefined;
      },
      error: (err) => {
        console.error('Failed to add product:', err);
        this.error = 'Failed to add product.';
      },
    });
  }
}

// Matches Spring model: Product(long id, String name, double price)
interface Product {
  id: number;
  name: string;
  price: number;
}

// Request body expected by POST /api/products
interface NewProduct {
  name: string;
  price: number;
}
