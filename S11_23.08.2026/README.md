# Pandas Fundamentals, Indexing, Alignment & Data Cleaning Cheat Sheet

A comprehensive technical reference covering pandas Series/DataFrame construction, structural attributes, label- vs. position-based indexing, reshaping and concatenation, aligned vectorized arithmetic, NaN-safe aggregation, boolean masking, and end-to-end data cleaning.

---

## 1. Series & DataFrame Creation

A `Series` is a 1D indexed array; a `DataFrame` is a 2D table made of aligned Series that share a common row index. Every column in a `DataFrame` is internally a `Series`.

### Construction Routines

| Constructor | Syntax Parameters | Output Properties | Primary Use Case |
| --- | --- | --- | --- |
| **`pd.Series(list)`** | `data, index=None` | Default integer index `0..N-1` | Wrapping a plain sequence with positional labels. |
| **`pd.Series(list, index=...)`** | `data, index=[...]` | Custom explicit labels | Associating values with meaningful, non-integer keys. |
| **`pd.Series(dict)`** | `data` | Keys become the index, in insertion order | Converting key/value data directly into a labeled array. |
| **`pd.DataFrame(dict_of_series)`** | `{col: Series/dict, ...}` | Columns aligned automatically on the union of all indices | Combining several related Series into one table. |
| **`pd.DataFrame(list_of_dicts)`** | `[{...}, {...}]` | Missing keys across rows become `NaN` | Row-oriented data such as API responses or JSON records. |
| **`pd.DataFrame(ndarray, columns=, index=)`** | `data, columns=[...], index=[...]` | Column/row labels applied on top of raw array data | Attaching labels to numeric data already in NumPy form. |
| **`pd.read_csv` / `read_excel` / `read_json` / `read_sql`** | `filepath_or_buffer` | Infers dtypes per column from file contents | Loading real-world tabular data from disk or a database. |

> **Engine Rules & Alignment**
> 1. **Index Alignment:** When building a `DataFrame` from a dict of Series, pandas aligns on the **union** of all Series indices — any key missing from one Series becomes `NaN` in that column.
> 2. **Label vs. Position:** A Series' index is independent of row order. Explicit labels (e.g. `'Egypt'`) coexist with an implicit positional order (`0, 1, 2, ...`) that `.iloc` always uses regardless of the labels.

### Code Examples: Creation & Alignment

```python
import numpy as np
import pandas as pd

# 1. Series with a default vs. explicit index
data = pd.Series([1, 2, 3, 4, 5])
data_labeled = pd.Series([1, 2, 3, 4, 5], index=['a', 'b', 'c', 'd', 'e'])

print("data:\n", data)
print("data_labeled:\n", data_labeled)
print("data_labeled['a']:", data_labeled['a'])
print("data_labeled[['b', 'e']]:\n", data_labeled[['b', 'e']])

# 2. Series directly from a dict -- keys become the index
dict_1 = {'Egypt': 300, 'USA': 2000, 'Canada': 1500}
data_dict = pd.Series(dict_1)
print("data_dict:\n", data_dict)
print("data_dict['Egypt':'Canada']:\n", data_dict['Egypt':'Canada'])  # label slice is INCLUSIVE

# 3. DataFrame from a dict of Series/dicts -- aligned automatically
population = {'Egypt': 120, 'KSA': 80, 'USA': 300}
area = {'Egypt': 1, 'KSA': 1.8, 'USA': 5}
countries = pd.DataFrame({'population': population, 'area': area})
print("countries:\n", countries)

# 4. DataFrame from a list of dicts -- mismatched keys fill with NaN
from_records = pd.DataFrame([{'a': 1, 'b': 2}, {'b': 5, 'c': 8}])
print("from_records:\n", from_records)

# 5. DataFrame from a raw NumPy array
from_numpy = pd.DataFrame(np.random.rand(3, 2), columns=['foo', 'bar'], index=list('abc'))
print("from_numpy:\n", from_numpy)
```

---

## 2. DataFrame Structural Attributes

pandas objects expose metadata attributes describing their shape, labels, and storage dtypes.

| Attribute | Return Type | Description / Calculation | Structural Purpose |
| --- | --- | --- | --- |
| **`shape`** | `tuple` | `(n_rows, n_columns)` | Overall table dimensions. |
| **`columns`** | `Index` | Column label array | Names of every field/variable in the table. |
| **`index`** | `Index` | Row label array | Labels identifying each row (default: `RangeIndex`). |
| **`dtypes`** | `Series` | Per-column data type | Storage type per column (`int64`, `float64`, `object`, `datetime64`, ...). |
| **`values`** | `ndarray` | Raw underlying data, labels stripped | Converts the table back to a plain NumPy array. |
| **`size`** | `int` | Total element count (`n_rows * n_columns`) | Total number of stored cells. |
| **`ndim`** | `int` | `1` for Series, `2` for DataFrame | Confirms object dimensionality. |

### Code Example: Inspecting Attributes

```python
area = pd.Series({'California': 423967, 'Texas': 695662, 'New York': 141297,
                   'Florida': 170312, 'Illinois': 149995})
pop = pd.Series({'California': 38332521, 'Texas': 26448193, 'New York': 19651127,
                  'Florida': 19552860, 'Illinois': 12882135})
states = pd.DataFrame({'area': area, 'pop': pop})

print(f"Shape:   {states.shape}")
print(f"Columns: {list(states.columns)}")
print(f"Index:   {list(states.index)}")
print(f"Dtypes:\n{states.dtypes}")
print(f"Values:\n{states.values}")

# Column access via bracket notation returns a Series
print("states['area']:\n", states['area'])

# Attribute-style access works ONLY when the column name doesn't collide with
# an existing DataFrame method -- 'pop' happens to be a built-in method name!
print("states.area is states['area']:", states.area is states['area'])
print("states.pop is states['pop']:", states.pop is states['pop'])
```

---

## 3. Indexing, Slicing, `loc`/`iloc` & Views vs. Copies

With an explicit, non-default index, plain bracket access becomes ambiguous between label and position — `.loc` and `.iloc` resolve that ambiguity explicitly.

| Operation | Syntax Example | Lookup Basis | Stop Bound Behavior |
| --- | --- | --- | --- |
| **Bracket indexing** | `s[1]` | Explicit label (if present) | N/A |
| **Bracket slicing** | `s[1:3]` | Implicit position (fallback) | Exclusive, like plain Python |
| **`.loc[]`** | `df.loc[row_label, col_label]` | **Label**-based | **Inclusive** of the stop label |
| **`.iloc[]`** | `df.iloc[row_pos, col_pos]` | **Position**-based | Exclusive, like plain Python |
| **`.at[]` / `.iat[]`** | `df.at[label, col]` / `df.iat[i, j]` | Single scalar, label / position | Fast scalar-only accessors |
| **`.copy()`** | `df.copy()` | N/A | Returns a fully detached copy |

> **View / Copy Pitfall**
> Chained indexing (e.g. `df[df.a > 0]['b'] = 1`) can silently operate on a temporary view and trigger a `SettingWithCopyWarning`. Use `.loc[row_mask, 'b'] = 1` for reliable in-place assignment, and call `.copy()` explicitly whenever a fully independent DataFrame is required.

### Code Example: Ambiguity, `loc`/`iloc`, and Copies

```python
s = pd.Series(['a', 'b', 'c'], index=[1, 2, 3])
print("s[1]:", s[1])          # label-based (explicit index)
print("s[1:3]:\n", s[1:3])    # position-based (implicit index) -- ambiguity!

print("s.loc[1:3]:\n", s.loc[1:3])   # label-based, inclusive
print("s.iloc[1:3]:\n", s.iloc[1:3]) # position-based, exclusive

# Positional and label-based 2D slicing
print("states.iloc[:3, :2]:\n", states.iloc[:3, :2])
print("states.loc[:'Illinois', :'pop']:\n", states.loc[:'Illinois', :'pop'])

# Fast scalar access
print("states.at['Texas', 'pop']:", states.at['Texas', 'pop'])
print("states.iat[1, 1]:", states.iat[1, 1])

# Explicit copy -- edits do NOT propagate back to the original
states_copy = states.copy()
states_copy.loc['Texas', 'pop'] = 0
print("original states unaffected:\n", states['pop'])
```

---

## 4. Reshaping & Concatenation

Reshaping restructures which column serves as the row index; concatenation joins separate DataFrames into one.

| Operation | Syntax | Constraints | Behavior |
| --- | --- | --- | --- |
| **`set_index()`** | `df.set_index('col')` | Column must exist | Promotes a column to the row index. |
| **`reset_index()`** | `df.set_index('col').reset_index()` | — | Moves the index back into an ordinary column (default `RangeIndex` restored). |
| **`pd.concat([...])`** | `pd.concat([a, b], ignore_index=True)` | Matching columns recommended | Stacks DataFrames row-wise; mismatched columns fill with `NaN`. |
| **`pd.concat([...], axis=1)`** | `pd.concat([a, b], axis=1)` | Aligns on shared index | Joins DataFrames side-by-side (column-wise). |

### Code Example: Reindexing and Concatenation

```python
orders_preview = pd.DataFrame({'OrderID': [1001, 1002, 1003], 'Customer': ['Sara', 'Omar', 'Nour']})

# Promote a column to the row index, then move it back
reindexed = orders_preview.set_index('OrderID')
print("reindexed:\n", reindexed)
print("reindexed.reset_index():\n", reindexed.reset_index())

# Concatenate two DataFrames by stacking rows
batch_1 = pd.DataFrame({'a': [1, 2], 'b': [3, 4]})
batch_2 = pd.DataFrame({'a': [5, 6], 'b': [7, 8]})
combined = pd.concat([batch_1, batch_2], ignore_index=True)
print("combined:\n", combined)
```

---

## 5. Vectorized Computation & Aligned Arithmetic

Arithmetic between pandas objects is automatically **aligned** on shared row/column labels before the operation runs — a key difference from raw NumPy broadcasting.

| Operator | Method Equivalent | `axis` Support | Alignment Behavior |
| --- | --- | --- | --- |
| `+` | `df.add(other)` | Yes | Adds matching labels; unmatched labels produce `NaN`. |
| `-` | `df.sub(other)` / `df.subtract(other)` | Yes | Subtracts matching labels; unmatched labels produce `NaN`. |
| `*` | `df.mul(other)` / `df.multiply(other)` | Yes | Element-wise product on aligned labels. |
| `/` | `df.div(other)` / `df.divide(other)` | Yes | Element-wise quotient on aligned labels. |
| — | `df.subtract(series, axis=0)` | Explicit | Broadcasts a Series down **each row** instead of matching columns. |

> **Alignment Pitfall**
> `df - df[['pop']]` only matches the `pop` column by name — every other column becomes `NaN` because there is nothing to align it with. Use `axis=0` with the method form (e.g. `.subtract(series, axis=0)`) to broadcast a Series across rows instead.

### Code Example: Aligned Arithmetic & Derived Columns

```python
print("states + states:\n", states + states)

# Column-name alignment: only 'pop' matches, everything else -> NaN
print("states - states[['pop']]:\n", states - states[['pop']])

# axis=0 broadcasts a Series down each row instead
print("states.subtract(states['pop'], axis=0):\n", states.subtract(states['pop'], axis=0))

# Vectorized division to derive a new column -- no explicit loop needed
states['density'] = states['pop'] / states['area']
print("states:\n", states)
```

---

## 6. Aggregations & Missing Data Handling

Aggregations summarize a column (or the whole table) into scalar statistics. `NaN` values require explicit detection and handling — pandas aggregations skip `NaN` by default (unlike raw NumPy's `np.sum`/`np.mean`).

| Method | Return | NaN Behavior | Purpose |
| --- | --- | --- | --- |
| `df['col'].sum()` / `.mean()` / `.min()` / `.max()` | scalar | **Ignores `NaN` by default** | Column-level summary statistics. |
| `df.info()` | prints summary | — | Row count, dtypes, and non-null counts per column. |
| `df.describe()` | `DataFrame` | Ignores `NaN` | Count/mean/std/quartiles for numeric columns. |
| `df.isnull()` / `df.isna()` | Boolean `DataFrame` | Flags missing cells | Detects `NaN`/`None` per cell; `.sum()` gives a per-column count. |
| `df.notnull()` | Boolean `DataFrame` | Inverse of `isnull()` | Flags present (non-missing) cells. |
| `df.dropna(how='any'/'all', thresh=n, subset=[...])` | filtered `DataFrame` | Removes rows/columns with missing data | Drops incomplete records by rule. |
| `df['col'].fillna(value)` | filled `Series`/`DataFrame` | Replaces `NaN` | Imputes missing values with a constant, statistic, or fill method. |

### Code Example: Aggregation and NaN Handling

```python
print("total pop:", states['pop'].sum())
print("mean density:", states['density'].mean())

states.info()
print("states.describe():\n", states.describe())

# Introduce a missing value, then detect and handle it
states.iloc[0, 2] = np.nan
print("missing values per column:\n", states.isnull().sum())
print("dropna(thresh=3):\n", states.dropna(axis=0, thresh=3))
print("dropna(how='any'):\n", states.dropna(how='any'))
```

---

## 7. Boolean Masking, Filtering & Sorting

Boolean masks evaluate a condition element-wise and select only the matching rows; sorting reorders rows or columns by value.

| Method / Operator | Operation Type | Return Structure | Behavioral Properties |
| --- | --- | --- | --- |
| `df['col'] > val` | Boolean evaluation | Boolean `Series` | `True`/`False` per row for the condition. |
| `df[mask]` | Boolean indexing | Filtered `DataFrame` | Keeps only rows where the mask is `True`. |
| `df[(cond1) & (cond2)]` | Combined mask (`&`/`|`) | Filtered `DataFrame` | Each condition **must** be parenthesized. |
| `df.query("expr")` | String-expression filter | Filtered `DataFrame` | Same result as a boolean mask, more readable syntax. |
| `df.sort_values('col', ascending=)` | Value-based sort | Reordered `DataFrame` | Orders rows by one or more column values. |
| `df.sort_index()` | Label-based sort | Reordered `DataFrame` | Restores/orders rows by their index labels. |

### Code Example: Filtering and Sorting

```python
df['Revenue'] = df['Quantity'] * df['UnitPrice']

# Single condition
print("orders over 200 revenue:\n", df[df['Revenue'] > 200])

# Multiple conditions -- each wrapped in parentheses
print("Cairo electronics:\n", df[(df['Region'] == 'Cairo') & (df['Category'] == 'Electronics')])

# Equivalent, more readable filter
print("same filter via .query():\n", df.query("Region == 'Cairo' and Category == 'Electronics'"))

# Sort by value, then restore original row order
df.sort_values('Revenue', ascending=False, inplace=True)
print("sorted by Revenue:\n", df)
df.sort_index(inplace=True)
```

---

## 8. Data Cleaning Toolkit

Real datasets rarely arrive clean — this section covers duplicate removal, string normalization, dtype casting, and value fixes.

| Method | Operation | Key Parameters | Purpose |
| --- | --- | --- | --- |
| `df.duplicated()` | Duplicate detection | `subset=`, `keep='first'/'last'/False` | Flags rows that repeat an earlier row. |
| `df.drop_duplicates()` | Duplicate removal | `subset=`, `keep=`, `inplace=` | Removes flagged duplicate rows. |
| `df['col'].str.strip()` | Whitespace trim | — | Equivalent to SQL `TRIM()`. |
| `df['col'].str.lower()` / `.str.title()` | Case normalization | — | Standardizes text casing. |
| `df['col'].astype(dtype)` | Type casting | `int`, `float`, `str`, `'category'`, ... | Explicitly converts a column's dtype. |
| `df['col'].replace(old, new)` | Value substitution | `old`, `new`, or a mapping dict | Swaps specific values for others. |
| `df['col'].clip(lower=, upper=)` | Range capping | `lower`, `upper` | Bounds outlier values into a fixed range. |

### Code Example: End-to-End Cleaning

```python
dirty = df.copy()
dirty.loc[2, 'Quantity'] = np.nan
dirty.loc[5, 'Region'] = None
dirty = pd.concat([dirty, dirty.iloc[[0]]], ignore_index=True)  # inject a duplicate row
print("missing values:\n", dirty.isnull().sum())

# Drop rows missing key fields, OR impute instead
cleaned_dropped = dirty.dropna(subset=['Quantity', 'Region'])
filled = dirty.copy()
filled['Quantity'] = filled['Quantity'].fillna(filled['Quantity'].median())
filled['Region'] = filled['Region'].fillna('Unknown')

# Remove duplicates
filled.drop_duplicates(inplace=True)

# Normalize text
filled['Customer'] = filled['Customer'].str.strip().str.lower()

# Cast dtype
filled['Revenue'] = filled['Revenue'].astype(float)

# Value substitution and outlier capping
print("relabeled:\n", filled['Region'].replace('Unknown', 'not specified'))
print("clipped quantity:\n", filled['Quantity'].clip(lower=1, upper=10))
```