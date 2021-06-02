defmodule Exlivery.Users.AgentTest do
  use ExUnit.Case

  alias Exlivery.Users.Agent, as: UserAgent
  alias Exlivery.Users.User

  import Exlivery.Factory

  describe "save/1" do
    test "saves the user" do
      UserAgent.start_link(%{})
      user = build(:user)
      assert UserAgent.save(user) == :ok
    end
  end

  describe "get/1" do
    setup do
      UserAgent.start_link(%{})
      :ok
    end

    test "when user is found, returns an user" do
      cpf = "00000000011"

      :user
      |> build(cpf: cpf)
      |> UserAgent.save()

      result = UserAgent.get(cpf)

      expected =
        {:ok,
         %User{
           name: "Joao",
           cpf: cpf,
           email: "joao@fake.co",
           age: 21,
           address: "Rua dos Bobos, nº 0"
         }}

      assert result == expected
    end

    test "when user is not found, returns an error" do
      result = UserAgent.get("00000000011")
      expected = {:error, "User not found"}
      assert result == expected
    end
  end
end