# NumPy Fundamentals, Array Operations, Ufuncs & Memory Mechanics Cheat Sheet

A comprehensive technical reference covering NumPy homogeneous memory structures, array initialization, dimensional attributes, slicing semantics, vectorized universal functions (ufuncs), NaN-safe aggregation, and boolean masking.

---

## 1. Data Coercion & Array Initialization Functions

NumPy requires homogeneous data structures stored in contiguous memory blocks. When constructing arrays from mixed-type Python collections, NumPy enforces implicit type coercion up the type hierarchy (`bool` $\rightarrow$ `int` $\rightarrow$ `float` $\rightarrow$ `string`).

### Array Creation Routines

| Initialization Method | Syntax Parameters | Output Properties | Primary Use Case |
| --- | --- | --- | --- |
| **`np.zeros`** | `shape` | Filled with `0.0` (`float64` default) | Pre-allocating zero-initialized array buffers. |
| **`np.ones`** | `shape` | Filled with `1.0` (`float64` default) | Multiplicative baseline arrays and weighting masks. |
| **`np.full`** | `shape, fill_value` | Filled with specified constant | Fixed baseline state initialization. |
| **`np.arange`** | `start, stop, step` | Half-open interval `[start, stop)` | Grid index sequences with defined increments. |
| **`np.linspace`** | `start, stop, num` | Closed interval `[start, stop]` with `num` points | Evenly spaced intervals for math sampling. |
| **`np.random.random`** | `shape` | Uniform random floats in `[0.0, 1.0)` | Stochastic baseline data and initial weights. |
| **`np.random.randint`** | `low, high, shape` | Random integers in `[low, high)` | Discrete simulation inputs and integer sampling. |
| **`np.eye`** | `N` | $N \times N$ matrix with ones on main diagonal | Linear algebra identity operations. |
| **`np.empty`** | `shape` | Uninitialized memory (garbage values) | Fast memory pre-allocation when populating later. |

> **Engine Rules & Type Coercion**
> 1. **Homogeneous Memory:** Array elements occupy a fixed, uniform byte size. Including a single string in a numeric collection forces the entire array to coerce to a Unicode string type (`<U...`).> 2. **Unallocated Memory Warning:** `np.empty()` does not set array values to zero; it returns whatever arbitrary bit patterns currently exist at the allocated memory address.

### Code Examples: Coercion & Initialization

```python
import numpy as np

# 1. Type Coercion: Heterogeneous Python List vs Homogeneous NumPy Array
py_list = [1, 2, 2.5, "Ahmed"]
int_array = np.array([1, 2, 3])
str_array = np.array([1, 2, 3, "4"]) # Implicitly coerced to string array

print("py_list:", py_list)
print("int_array:", int_array)
print("str_array:", str_array)

# 2. Initializing Arrays from Scratch
zeros_arr = np.zeros(10)
ones_arr = np.ones((3, 5))
full_arr = np.full((3, 5), 3.14)
step_arr = np.arange(0, 21, 2)
linspace_arr = np.linspace(0, 1, 5)
rand_float_arr = np.random.random((3, 5))
rand_int_arr = np.random.randint(0, 6, (3, 5))
identity_matrix = np.eye(3)
empty_arr = np.empty((3, 5))

print("zeros_arr:\n", zeros_arr)
print("ones_arr:\n", ones_arr)
print("full_arr:\n", full_arr)
print("step_arr:\n", step_arr)
print("linspace_arr:\n", linspace_arr)
print("rand_float_arr:\n", rand_float_arr)
print("rand_int_arr:\n", rand_int_arr)
print("identity_matrix:\n", identity_matrix)
print("empty_arr:\n", empty_arr)
```

---

## 2. Array Structural Attributes & Memory Footprint

NumPy arrays track structural layout and memory requirements via low-level metadata attributes.

| Attribute | Return Type | Description / Calculation | Structural Purpose |
| --- | --- | --- | --- |
| **`ndim`** | `int` | Number of array axes (dimensions) | Identifies vector (1), matrix (2), or tensor (3+) rank. |
| **`shape`** | `tuple` | Tuple of integers $(d_1, d_2, \dots, d_k)$ | Specifies dimension lengths across all axes. |
| **`size`** | `int` | Total element count ($\prod d_i$) | Total number of elements stored across the array. |
| **`dtype`** | `dtype` | Data type object (`int64`, `float64`, etc.) | Defines bit-depth and interpretation of stored memory. |
| **`itemsize`** | `int` | Memory consumption per element in bytes | Single element memory footprint ($32 \text{ bits} = 4 \text{ bytes}$). |
| **`nbytes`** | `int` | Total memory allocation ($\text{size} \times \text{itemsize}$) | Complete byte allocation consumed by the array buffer. |

### Code Example: Inspecting Attributes

```python
# Sample 2D array allocation
x = np.random.randint(0, 10, (3, 5))
print("x:\n", x)

# Structural property inspection
print(f"Dimensions (ndim): {x.ndim}")
print(f"Shape:            {x.shape}")
print(f"Total elements:   {x.size}")
print(f"Data type:        {x.dtype}")
print(f"Item size (bytes):{x.itemsize}")
print(f"Total size (bytes):{x.nbytes}")
```

---

## 3. Indexing, Slicing & Memory Views vs. Copies

Array slicing in NumPy returns **views** rather than copies to maintain computational speed and zero-copy memory performance.

| Operation | Syntax Example | Output Memory Behavior | Modifications Mutate Original? |
| --- | --- | --- | --- |
| **1D Indexing** | `x1[0]`, `x1[-1]` | Scalar value extraction | N/A (Returns copy of scalar) |
| **1D Slicing** | `x1[start:stop:step]` | **Memory View** | **Yes** — Mutating slice modifies source array |
| **2D Indexing** | `x[row, col]` | Single element access | N/A |
| **2D Slicing** | `x[0:2, 0:2]` | **Subarray View** | **Yes** — Shared underlying memory buffer |
| **Explicit Copy** | `x[0:2, 0:2].copy()` | **Allocated Copy** | **No** — Completely detached memory buffer |

> **Memory View Pitfall**
> Direct assignment to a sliced subarray (`sub = x[0:2, 0:2]; sub[0,0] = 99`) mutates `x[0,0]` directly. Always use `.copy()` when slice detachment is required.

### Code Example: Indexing, Slicing, and Copies

```python
x1 = np.array([1, 2, 3, 4, 5])

# Element access and 1D Slicing
first_elem = x1[0]
last_elem = x1[-1]
sub_first_three = x1[0:3]
sub_every_other = x1[::2]
sub_reversed = x1[::-1]

print("x1:", x1)
print("first_elem:", first_elem)
print("last_elem:", last_elem)
print("sub_first_three:", sub_first_three)
print("sub_every_other:", sub_every_other)
print("sub_reversed:", sub_reversed)

# 2D Indexing, Slicing, View Mutation vs Copy Detachment
x = np.random.randint(0, 10, (3, 5))
corner_val = x[-1, -1]
x[0, 0] = 10  # In-place scalar update

sub_2x2 = x[0:2, 0:2]  # Memory View
y = x[0:2, 0:2].copy() # Explicit Copy Allocation
y[0, 0] = 100          # Does not affect original matrix x

print("corner_val:", corner_val)
print("Modified x:\n", x)
print("sub_2x2:\n", sub_2x2)
print("y (copy modified):\n", y)
```

---

## 4. Dimensional Reshaping & Concatenation

Reshaping alters dimensional organization without altering underlying data bytes. Concatenation joins multiple arrays along a specified target axis.

| Operation | Syntax | Dimension Constraints | Axis Behavior |
| --- | --- | --- | --- |
| **`reshape()`** | `arr.reshape((r, c))` | Target size ($\prod \text{new}$) must equal original size | Reinterprets row/column dimensions without modifying data buffer. |
| **Concatenate (1D)** | `np.concatenate([a1, a2])` | Both inputs must be 1D vectors | Appends arrays end-to-end into a single 1D vector. |
| **Concatenate (2D Axis 0)** | `np.concatenate([a, b], axis=0)` | Column dimensions must match ($C_a = C_b$) | Stacks matrices vertically (adds rows). |
| **Concatenate (2D Axis 1)** | `np.concatenate([a, b], axis=1)` | Row dimensions must match ($R_a = R_b$) | Stacks matrices horizontally (adds columns). |

### Code Example: Reshaping and Concatenation

```python
# 1. Reshaping 1D sequence into 2D Matrix
grid_3x3 = np.arange(0, 9).reshape((3, 3))
print("grid_3x3:\n", grid_3x3)

# 2. 1D Array Concatenation
arr1 = np.array([1, 2, 3])
arr2 = np.array([4, 5, 6])
combined_1d = np.concatenate([arr1, arr2])
print("combined_1d:", combined_1d)

# 3. 2D Array Concatenation along Columns (Axis 1)
grid = np.arange(1, 7).reshape((2, 3))
combined_2d = np.concatenate([grid, grid], axis=1)
print("combined_2d:\n", combined_2d)
```

---

## 5. Vectorization & Universal Functions (Ufuncs)

Universal functions (`ufuncs`) execute element-wise operations directly in compiled C code, eliminating native Python loops.

| Operator | Native Ufunc Equivalent | Operation | Mathematical Property |
| --- | --- | --- | --- |
| `+` | `np.add(x1, x2)` | Addition | Element-wise sum. |
| `-` | `np.subtract(x1, x2)` | Subtraction | Element-wise difference. |
| `-x` | `np.negative(x)` | Negation | Unary sign inversion. |
| `*` | `np.multiply(x1, x2)` | Multiplication | Element-wise product. |
| `/` | `np.divide(x1, x2)` | Division | Floating-point division. |
| `//` | `np.floor_divide(x1, x2)` | Floor Division | Truncates fractional remainder. |
| `**` | `np.power(x1, x2)` | Exponentiation | Base elevated to exponent power. |
| `%` | `np.remainder(x1, x2)` | Modulus | Division remainder. |
| `abs()` | `np.absolute(x)` | Absolute Value | Absolute magnitude scalar computation. |

### Code Example: Operators, Ufuncs & Trigonometry

```python
arr_vec = np.arange(4)

# Native Python Arithmetic Operators (Vectorized via ufuncs)
add_res = arr_vec + 5
sub_res = arr_vec - 5
mul_res = arr_vec * 2
div_res = arr_vec / 2
floor_div_res = arr_vec // 2
pow_res = arr_vec ** 2
mod_res = arr_vec % 2

print("arr_vec:", arr_vec)
print("add_res:", add_res)
print("sub_res:", sub_res)
print("mul_res:", mul_res)
print("div_res:", div_res)
print("floor_div_res:", floor_div_res)
print("pow_res:", pow_res)
print("mod_res:", mod_res)

# Direct NumPy Ufuncs
np_add = np.add(arr_vec, 2)
np_sub = np.subtract(arr_vec, 2)
np_neg = np.negative(arr_vec)
np_mul = np.multiply(arr_vec, 5)
np_abs = np.absolute(-arr_vec)

print("np_add:", np_add)
print("np_sub:", np_sub)
print("np_neg:", np_neg)
print("np_mul:", np_mul)
print("np_abs:", np_abs)

# Trigonometric Ufuncs
theta = np.linspace(0, np.pi, 3)
sin_vals = np.sin(theta)
cos_vals = np.cos(theta)

print("theta:", theta)
print("sin_vals:", sin_vals)
print("cos_vals:", cos_vals)
```

---

## 6. Aggregations & Missing Data (NaN) Handling

Aggregations summarize multidimensional datasets into scalar values or reduced axis vectors. Operating on arrays containing `NaN` (Not a Number) values requires specialized `nan-`aware aggregations.

| Standard Aggregation | NaN-Safe Equivalent | Standard NaN Behavior | Safe NaN Behavior |
| --- | --- | --- | --- |
| `np.sum(a)` / `a.sum()` | `np.nansum(a)` | Propagates `NaN` (returns `NaN`) | Ignores `NaN` values and computes total sum. |
| `np.mean(a)` | `np.nanmean(a)` | Propagates `NaN` (returns `NaN`) | Computes arithmetic mean over non-NaN values. |
| `np.median(a)` | `np.nanmedian(a)` | Propagates `NaN` (returns `NaN`) | Computes median ignoring missing entries. |
| `np.min(a)` | `np.nanmin(a)` | Propagates `NaN` (returns `NaN`) | Returns global minimum ignoring `NaN`. |
| `np.max(a)` | `np.nanmax(a)` | Propagates `NaN` (returns `NaN`) | Returns global maximum ignoring `NaN`. |

### Code Example: Reductions, Axis Aggregations, and NaN Handling

```python
# 1. Ufunc Reduction Operations
arr_reduce = np.arange(4)
sum_reduced = np.add.reduce(arr_reduce)      # 0 + 1 + 2 + 3
prod_reduced = np.multiply.reduce(arr_reduce) # 0 * 1 * 2 * 3

print("sum_reduced:", sum_reduced)
print("prod_reduced:", prod_reduced)

# 2. Standard Aggregations & Multidimensional Axis Sums
min_val = np.min(arr_reduce)
max_val = np.max(arr_reduce)
total_sum = np.sum(arr_reduce)
column_sums = grid.sum(axis=0) # Collapses rows, aggregates columns

print("min_val:", min_val)
print("max_val:", max_val)
print("total_sum:", total_sum)
print("column_sums:", column_sums)

# 3. NaN Handling Comparison
nan_array = np.array([1.0, 2.0, 3.0, 4.0, np.nan])
safe_sum = np.nansum(nan_array)
safe_mean = np.nanmean(nan_array)
safe_median = np.nanmedian(nan_array)

print("nan_array:", nan_array)
print("safe_sum:", safe_sum)
print("safe_mean:", safe_mean)
print("safe_median:", safe_median)
```

---

## 7. Boolean Masking & Sorting

Boolean masking evaluates vectorized search conditions against arrays to return subsetted output buffers.

| Method / Operator | Operation Type | Return Structure | Behavioral Properties |
| --- | --- | --- | --- |
| `a > val` | Boolean Evaluation | Boolean Array (`bool_`) | Evaluates expression per element returning `True`/`False`. |
| `a[mask]` | Boolean Indexing | 1D Array Subset | Extracts elements corresponding to `True` positions. |
| `arr.sort()` | In-Place Sort | `None` (Mutates original) | Sorts underlying contiguous array buffer directly in memory. |
| `np.isnan(val)` | NaN Identification | Boolean Indicator | Returns `True` if specific value/element is `NaN`. |

### Code Example: Filtering, In-Place Sorting, and NaN Checks

```python
data = np.array([1.0, 2.0, 3.0, 4.0, np.nan])

# 1. Boolean Masking & Subset Filtering
mask = data > 2
filtered_data = data[data > 2]

print("data:", data)
print("mask:", mask)
print("filtered_data:", filtered_data)

# 2. In-Place Array Sorting
unsorted_arr = np.array([50, 2, 25, 18, 7, 10])
unsorted_arr.sort() # Mutates array directly

print("sorted_arr:", unsorted_arr)

# 3. Floating-point NaN Verification
has_nan = np.isnan(np.nan)
print("has_nan:", has_nan)
```