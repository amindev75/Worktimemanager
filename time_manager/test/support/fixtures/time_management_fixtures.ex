defmodule TimeManager.TimeManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.TimeManagement` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 09:30:00]
      })
      |> TimeManager.TimeManagement.create_clock()

    clock
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 09:30:00],
        start: ~N[2024-10-07 09:30:00]
      })
      |> TimeManager.TimeManagement.create_workingtime()

    workingtime
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 09:34:00],
        start: ~N[2024-10-07 09:34:00]
      })
      |> TimeManager.TimeManagement.create_workingtime()

    workingtime
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 09:34:00]
      })
      |> TimeManager.TimeManagement.create_clock()

    clock
  end
end
