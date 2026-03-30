import streamlit as st
import pandas as pd
from datetime import timedelta

st.set_page_config(
    page_title="AMS specialist engagement weekly",
    page_icon=":material/group:",
    layout="wide",
)

st.title("AMS specialist engagement weekly")
st.caption("7-day specialist comment and activity snapshot for AMS AFE & Architect teams")


@st.cache_data(ttl=timedelta(minutes=10))
def load_data():
    conn = st.connection("snowflake")
    return conn.query("""
        SELECT
            EMPLOYEE_NAME, SPECIALIST_COMMENTS_7D, ACTIVITIES_7D,
            ACTIVITIES_7D_SETSAIL, ACTIVITIES_7D_VIVUN, MANAGER_NAME,
            THIRD_LINE_MANAGER, SPECIALIST_GROUP, SPECIALIST_SUB_GROUP,
            SPECIALIST_THEATER, SPECIALIST_THEATER_MARKET, IS_MANAGER
        FROM SPECIALIST_ENGAGEMENT_WEEKLY
        WHERE IS_MANAGER = 'N'
    """)


df = load_data()

# --- sidebar filters ---
with st.sidebar:
    st.header("Filters")

    groups = sorted(df["SPECIALIST_GROUP"].dropna().unique())
    selected_groups = st.multiselect("Specialist group", groups, default=groups)

    sub_groups = sorted(df["SPECIALIST_SUB_GROUP"].dropna().unique())
    selected_sub_groups = st.multiselect("Sub-group", sub_groups, default=sub_groups)

    markets = sorted(df["SPECIALIST_THEATER_MARKET"].dropna().unique())
    selected_markets = st.multiselect("Theater market", markets, default=markets)

    managers = sorted(df["MANAGER_NAME"].dropna().unique())
    selected_managers = st.multiselect("Manager", managers, default=managers)

    third_line = sorted(df["THIRD_LINE_MANAGER"].dropna().unique())
    selected_third_line = st.multiselect("Third-line manager", third_line, default=third_line)

# --- apply filters ---
filtered = df[
    df["SPECIALIST_GROUP"].isin(selected_groups)
    & df["SPECIALIST_SUB_GROUP"].isin(selected_sub_groups)
    & df["SPECIALIST_THEATER_MARKET"].isin(selected_markets)
    & df["MANAGER_NAME"].isin(selected_managers)
    & df["THIRD_LINE_MANAGER"].isin(selected_third_line)
]

# --- split by comment activity ---
has_comments = filtered[filtered["SPECIALIST_COMMENTS_7D"] > 0].copy()
no_comments = filtered[filtered["SPECIALIST_COMMENTS_7D"] == 0].copy()

# --- KPI row ---
with st.container(horizontal=True):
    st.metric("Total specialists", len(filtered), border=True)
    st.metric(
        "With comments (7d)",
        len(has_comments),
        border=True,
    )
    st.metric(
        "Without comments (7d)",
        len(no_comments),
        border=True,
    )
    pct = (
        f"{len(has_comments) / len(filtered) * 100:.0f}%"
        if len(filtered) > 0
        else "N/A"
    )
    st.metric("Comment rate", pct, border=True)
    st.metric("Setsail activities", int(filtered["ACTIVITIES_7D_SETSAIL"].sum()), border=True)
    st.metric("Vivun activities", int(filtered["ACTIVITIES_7D_VIVUN"].sum()), border=True)

# --- column display order ---
display_cols = [
    "EMPLOYEE_NAME",
    "SPECIALIST_COMMENTS_7D",
    "ACTIVITIES_7D",
    "ACTIVITIES_7D_SETSAIL",
    "ACTIVITIES_7D_VIVUN",
    "SPECIALIST_GROUP",
    "SPECIALIST_SUB_GROUP",
    "SPECIALIST_THEATER_MARKET",
    "MANAGER_NAME",
    "THIRD_LINE_MANAGER",
]

rename_map = {
    "EMPLOYEE_NAME": "Name",
    "SPECIALIST_COMMENTS_7D": "Comments (7d)",
    "ACTIVITIES_7D": "Activities (7d)",
    "ACTIVITIES_7D_SETSAIL": "Setsail (7d)",
    "ACTIVITIES_7D_VIVUN": "Vivun (7d)",
    "SPECIALIST_GROUP": "Group",
    "SPECIALIST_SUB_GROUP": "Sub-group",
    "SPECIALIST_THEATER_MARKET": "Market",
    "MANAGER_NAME": "Manager",
    "THIRD_LINE_MANAGER": "3rd-line manager",
}

# --- tables ---
tab_no, tab_yes = st.tabs(
    [
        f":material/warning: No comments ({len(no_comments)})",
        f":material/check_circle: Has comments ({len(has_comments)})",
    ]
)

with tab_no:
    if no_comments.empty:
        st.info("Everyone has entered comments this week.", icon=":material/celebration:")
    else:
        st.dataframe(
            no_comments[display_cols]
            .sort_values("ACTIVITIES_7D", ascending=False)
            .rename(columns=rename_map),
            hide_index=True,
            use_container_width=True,
        )

with tab_yes:
    if has_comments.empty:
        st.warning("No specialists have comments in the last 7 days.", icon=":material/info:")
    else:
        st.dataframe(
            has_comments[display_cols]
            .sort_values("SPECIALIST_COMMENTS_7D", ascending=False)
            .rename(columns=rename_map),
            hide_index=True,
            use_container_width=True,
        )
