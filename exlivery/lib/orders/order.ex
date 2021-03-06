defmodule Exlivery.Orders.Order do
  @keys [:user_cpf, :delivery_address, :items, :total_price]
  @enforce_keys @keys

  alias Exlivery.Orders.Item
  alias Exlivery.Users.User

  defstruct @keys

  def build(%User{cpf: cpf, address: address}, [%Item{} | _items] = items) do
    {:ok,
     %__MODULE__{
       user_cpf: cpf,
       delivery_address: address,
       items: items,
       total_price: calculate_total_price(items)
     }}
  end

  def build(_, _), do: {:error, "Invalid parameters"}

  defp calculate_total_price(items) do
    Enum.reduce(items, Decimal.new("0"), &sum_price/2)
  end

  defp sum_price(%Item{unity_price: price, quantity: quantity}, acc) do
    price
    |> Decimal.mult(quantity)
    |> Decimal.add(acc)
  end
end
